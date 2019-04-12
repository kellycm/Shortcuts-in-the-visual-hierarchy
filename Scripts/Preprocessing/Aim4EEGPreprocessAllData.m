% EEG Preprocessing for Aim4 of CRCNS
% a). Artifact rejection (by threshold and by improbability) b). Filtering c). Segmentation d). Baselining
% e). Rereferencing (if desired) f). Read Channel locations

function [eegdata EEG] = Aim4EEGPreprocessAllData(subjectDir,subj,badChan)
%subj = lower(input('Subject name >> ', 's'));

% pre = lower(input('Pre-training? (y/n) >> ', 's'));
% if isequal(pre, 'y')
%     prepost = 'pre';
% else
%     prepost = 'post';
% end
    
    %directory = [subj filesep subj prepost 'EEG' filesep];
    %directory = ['/home/kelly/Desktop/subjects/' subj '/' prepost '/allchans/'];
    %cd(directory)
    cd(subjectDir)
    %rawfiles = dir([directory '*.raw']);
    %matfiles = dir([directory '*.mat']);
    rawfiles = dir('*.raw');
    matfiles = dir([subj '.*.mat']);
    
    if length(rawfiles) ~= length(matfiles)
        disp('WARNING: EEG/matlab data file number mismatch')
    end
    
    %bad_chans = {[],[],[],[],[],[],[],[],[],[]};
    bad_chans = badChan;
    
    params.samplerate = 500;
    params.resample = 0;
    params.filter = 1;
    params.filtersettings = [.2, 0, 0, 30]; % highpass .1Hz, lowpass 40Hz
    params.rereference = 0;
    params.reworkDINs = 0;
    params.bad_chans = bad_chans;
    params.interpolate = 1;
    params.detrend = 0;
    params.baseline = 1;
    
    startpoint = -0.2;
    endpoint = 0.5;
    
    for block = 1:length(rawfiles)
        disp(['Processing data for block: ' num2str(block)])
        %rawfile = dir([directory '*' num2str(block) '.raw']);
        rawfile=dir(['*' num2str(block) '.raw']);

        if isempty(rawfile)
            disp(['WARNING: no raw file found for block num ' num2str(block)])
        elseif length(rawfile) ~= 1
            disp(['WARNING: more than one raw file found for block num ' num2str(block)])
        else
            %matfile = dir([directory '*' num2str(block) '.mat']);
            matfile = dir(['*' num2str(block) '.mat']);

            if isempty(matfile)
                disp(['WARNING: no mat file found for block num ' num2str(block)])
            elseif length(matfile) > 1
                disp(['WARNING: more than one mat file found for block num ' num2str(block)])
            end
            
            eegfilename = [subjectDir '/' rawfile(1).name];
            experimentfilename = [subjectDir '/' matfile(1).name];
            
            %  EEGLAB Filtering, Baselining, Artifact Rejection, Segmentation
            [EEG, ALLEEG, CURRENTSET, ArtifactIndices, processedeegfilename] = preprocessEEGLAB(eegfilename, experimentfilename, params, subj, block, startpoint, endpoint);
            
            eegdata.processedFilename = processedeegfilename;
            eegdata.filterSettings = params.filtersettings;
            eegdata.sampleRate = params.samplerate;
            
            %pop_saveset(EEG,'filename',[processedeegfilename  '.set'], 'savemode', 'onefile');
            save([eegdata.processedFilename '_continuous_EEGDATA_allchans.mat'], 'eegdata');
        end
        
    end
end
    
    function [EEG, ALLEEG, CURRENTSET, ArtifactIndices, processedeegfilename] = preprocessEEGLAB(eegfilename, experimentfilename, params, subj, block, startpoint, endpoint)
    if nargin < 6
        startpoint = -0.2;
        endpoint = 0.8;
        disp(['Using default startpoint=' num2str(startpoint) ' and endpoint=' endpoint]);
    end
    
    filtersettings = params.filtersettings;
    filter = params.filter;
    samplerate = params.samplerate;
    resample = params.resample;
    reference = params.rereference;
    interpolate = params.interpolate;
    bad_chans = params.bad_chans;
    detrend = params.detrend;
    baseline = params.baseline;
    infoString = '';
    
    tic;
    % Load eeglab
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Load the dataset
    %{
    if size(strfind(eegfilename,'001.raw'),2 > 0)
        EEG = pop_readsegegi(eegfilename);
    else
        EEG = pop_readegi(eegfilename);
    end
    %}
    EEG = pop_readegi(eegfilename);
    
    % Load matlab data
    load(experimentfilename); %CRCNS faces stim_final_Graycorr_S#.mat data
    
    % Load the channel location file
    EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load', {'Hydrocel_GSN_128_1.0_TRIM_mod.sfp', 'filetype', 'autodetect'});
    
    % Store the dataset into EEGLAB
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
    
    
    % % %
    % % %  RESAMPLE
    % % %
    if resample
        if EEG.srate ~= samplerate
            resampleit = 1;
        end
    end
    
    if resample && resampleit
        [EEG] = pop_resample( EEG, samplerate);
        EEG.comments = pop_comments(EEG.comments, '', ['Dataset was resampled at ' samplerate 'hz'], 1);
        infoString = ['SampleRate' num2str(samplerate) 'hz'];
    else
        infoString = ['SampleRate' num2str(EEG.srate) 'hz'];
    end
    
    
    % % %
    % % %  INTERPOLATE
    % % %
    if interpolate
        if ~isempty(bad_chans{block})
            EEG = eeg_interp(EEG, bad_chans{block}, 'spherical');
            EEG.comments = pop_comments(EEG.comments, '', 'Bad channels were interpolated spherically', 1);
            infoString = [infoString '_INTERPOLATED'];
        end
    end
    
    
    % % %
    % % %  DETREND
    % % %
    if detrend
        EEG = eeg_detrend(EEG);
        EEG.comments = pop_comments(EEG.comments, '', 'Dataset was detrended', 1);
        infoString = [infoString '_DETRENDED'];
    end
    
    
    % % %
    % % %  FILTER
    % % %
    if filter && (filtersettings(1, 1) > 0 || filtersettings(1, 2) > 0 || filtersettings(1, 3) > 0 || filtersettings(1, 4) > 0)
        usefilter = 1;
    else
        usefilter = 0;
    end
    
    if usefilter
        highpass = filtersettings(1, 1);
        lownotch = filtersettings(1, 2);
        highnotch = filtersettings(1, 3);
        lowpass = filtersettings(1, 4);
        
        if lowpass ~= 0 && highpass ~= 0
            % New bandpass fir filter with cutoffs of highpass Hz and lowpass Hz
            %EEG = pop_eegfiltnew(EEG, highpass, lowpass);
            EEG = pop_eegfiltnew(EEG, highpass, lowpass, [],[],[],[],1);
        elseif lowpass ~= 0
            % Low pass filter the data with frequency of lowpass Hz.
            %EEG = pop_eegfilt(EEG, 0, lowpass, 0, 0);
            EEG = pop_eegfilt(EEG, 0, lowpass, 0, 0, [], [], [],1);
        elseif highpass ~= 0
            % High pass filter the data with cutoff frequency of highpass Hz.
            %EEG = pop_eegfilt(EEG, highpass, 0, 0, 0);
            EEG = pop_eegfilt(EEG, highpass, 0, 0, 0,[],[],[],1);
        end
        
        % Notch filter the data with cutoff frequency of lownotch-highnotch (55-65) Hz.
        if lownotch ~= 0 && highnotch ~= 0
            EEG = pop_iirfilt(EEG, lownotch, highnotch, 0,1);
        end
        
        
        
        % Create new dataset named 'filtered Continuous EEG Data'
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', 'filtered Continuous EEG Data'); % Now CURRENTSET = 2
        
        % Save the EEG dataset structure
        %infoString = [infoString '_' num2str(highpass) 'hz-' num2str(lownotch) 'hz-' num2str(highnotch) 'hz-' num2str(lowpass) 'hz_FILTERED_DINS' num2str(params.reworkDINs)];
        infoString = [infoString '_' num2str(highpass) 'hz-' num2str(lowpass) 'hz_FILTERED'];
        
        EEG.comments = pop_comments(EEG.comments, '', ['Dataset was filtered ' infoString],1);
        setfilename = strrep(eegfilename, '.raw', infoString);
        % pop_saveset(EEG,'filename',[setfilename '.set'],'savemode','onefile');
    else
        setfilename = strrep(eegfilename, '.raw', infoString);
        infoString = [infoString '_' 'NOTFILTERED_DINS' num2str(params.reworkDINs)];
    end
    
    %pop_saveset(EEG, 'filename', [setfilename 'filtered_continuous.set'], 'savemode', 'onefile');
    
    
    
    % DIN reworking, epoch removal specific to old study
    %{
    
    % % %
    % % % DIN REWORKING FOR AB EXPERIMENT
    % % %
    directoryname = pwd;
   
    % isDarpaT1 = length(strfind(directoryname,'T1'));   %don't rework

    isRSVPAnA = length(strfind(directoryname,'RSVPAnimalNoAnimal'));
    isRSVPDarpa = length(strfind(directoryname,'RSVPDarpaNoDarpa')) && length(strfind(eegfilename,'subj01'));
    isRSVPDarpaT1 = length(strfind(directoryname,'RSVPDarpaNoDarpaT1'));  % rework S1's experiment
    isParallelDarpa = length(strfind(directoryname,'RSVPParallelDarpaNoDarpa'));  % rework all for now
    isParallelAnA = length(strfind(directoryname,'RSVPParallelAnimalNoAnimal'));  % rework all for now
    % isParallelAnA = 0;
    % isParallelDarpa = 0;
   
    % reworkDINs  = isRSVPAnA ||  isParallelDarpa || isParallelAnA || isRSVPDarpaT1 || isRSVPDarpa;
    reworkDINs = params.reworkDINs;

    %%%%%%DELETE FROM EVENT PARAMETER THE BOUNDARY EVENTS**************
    EEG = pop_editeventvals(EEG, 'delete', find(strcmp({EEG.event.type}, 'boundary')))
    %%%%%%DELETE FROM EVENT PARAMETER THE BOUNDARY EVENTS**************


    rejectindices = [];
    if reworkDINs
        disp('Reworking DINs for FIXATION ONSET TIME');
        % [EEG rejectindices] = fixABDINpositions(experimentfilename,EEG);
        % EEG = EEG.pop_rejepoch(EEG,rejectindices,0);  Don't actually
        % reject in the data structure, instead just do it later in
        % eegdata.data in convertToMaxLab(EEG,eegdata);
        %EEG.comments = pop_comments(EEG.comments,'','DINS were reworked for distractor only streams.',1);

        eegdata = quickAccuracy(experimentfilename);

        for q = 1:length(eegdata.interTrialDuration);
            timeShift = round(eegdata.interTrialDuration(q)*100)/100 + 0.5;

            currentlatency = EEG.event(q).latency;
            newlatency = currentlatency - timeShift;
            EEG.event(q).latency = newlatency;
            clear currentlatency newlatency timeshift;
        end

        EEG.comments = pop_comments(EEG.comments,'','DINS shifted to fixation onset time.',1);
    end
   
   
   
   
    if strcmp(params.expttype,'ADAPT');
        %find bad dins and remove!!!
        for qqq=1:2406
            latencies(qqq)=EEG.event(qqq).latency;
            if qqq+1<2407
                postLatency(qqq) = EEG.event(qqq+1).latency-EEG.event(qqq).latency;
            end
        end
    %%
    DINStoRemove = find(postLatency<10)+1;
    %%
    EEG = pop_editeventvals(EEG, 'delete', DINStoRemove)
        
    %%%---------------%%%

    %%%CAS REWORK DINS%%%
    %Make the DINS even/odd
    for i=1:length(EEG.event)
        %order = EEG.event(i).urevent;
        if mod(i,2)%mod(order,2)
            EEG.event(i).type = 'DIN1';
        else
            EEG.event(i).type = 'DIN2';
            endclose
    end
    
    %%%---------------%%%
    %}
    
    
    % % %
    % % %  DIN reworking and rejecting for Aim4 CRCNS
    % % %
    
    numEvents = length(EEG.event);
    if numEvents ~= 96
        error('Wrong number of DINs in data');
    end
    disp(['Number of events before DIN rework-reject: ' num2str(length(EEG.event))])
    remFix = [];
    remWrong = [];
    for e = 1:length(EEG.event)
        fix = trialData(e).fixationSuccessful;
        if ~fix
            EEG.event(e).type = 'DIN0';
            remFix = [remFix, e];
        else
            tType = trialData(e).trialType;
            EEG.event(e).type = ['DIN' num2str(tType)];
            right = trialData(e).subjectHasRightAnswer;
            if ~right
                %remWrong = [remWrong, e];
            end
        end
    end
    
    disp(['Num of aborted trial being removed this block: ' num2str(length(remFix))]);
    %if length(remWrong) < 8
    disp(['Num of incorrect response trials being removed this block: ' num2str(length(remWrong))]);
    rem = union(remFix, remWrong);
    %else
    %    disp(['Num of incorrect trials this block too large: ' num2str(length(remWrong)) '.  Not being removed.']);
    %    rem = remFix;
    %end
    EEG = pop_editeventvals(EEG, 'delete', rem);
    
    
    
    % % %
    % % %  DIN reworking and rejecting for CRCNS Faces
    % % %
    %{
    numEvents = length(EEG.event);
    if numEvents ~= 100
        error('Wrong number of DINs');
    end
    disp(['Number of events before DIN rework-reject: ' num2str(length(EEG.event))])
    remFix = No_image((block - 1)*100 < No_image & No_image <= block*100);
    remFix = remFix - (block - 1)*100;
    remWrong = [];
    
    %1: right, ecc1, up
    %2: right, ecc1, inv
    %3: right, ecc2, up
    %4: right, ecc2, inv
    %5: left, ecc1, up
    %6: left, ecc1, inv
    %7: left, ecc2, up
    %8: left, ecc2, inv
    side = stimulus_string.sideface;
    for e = 1:length(EEG.event)
        ecc = stimulus_string.ecc((block - 1)*100 + e);
        orientation = stimulus_string.NonFace((block - 1)*100 + e);
        if strcmp(side, 'right')
            if ecc == 1
                if orientation == 1
                    tType = 1;
                else
                    tType = 2;
                end
            else
                if orientation == 1
                    tType = 3;
                else
                    tType = 4;
                end
            end
        else
            if ecc == 1
                if orientation == 1
                    tType = 5;
                else
                    tType = 6;
                end
            else
                if orientation == 1
                    tType = 7;
                else
                    tType = 8;
                end
            end
        end
        EEG.event(e).type = ['DIN' num2str(tType)];
        right = (stimulus_string.NonFace((block - 1)*100 + e) == 1 && responseDt_tot.resp((block - 1)*100 + e) == 1) || ...
            (stimulus_string.NonFace((block - 1)*100 + e) == 2 && responseDt_tot.resp((block - 1)*100 + e) == 3);
        if ~right
            remWrong = [remWrong, e];
        end
    end
    
    disp(['Num of aborted trial being removed this block: ' num2str(length(remFix))]);
    remove = union(remFix, remWrong);
    %{
    if length(remWrong) < 8
        disp(['Num of incorrect response trials being removed this block: ' num2str(length(remWrong))]);
        remove = union(remFix, remWrong);
    else
        disp(['Num of incorrect trials this block too large: ' num2str(length(remWrong)) '.  Not being removed.']);
        remove = remFix;
    end
    %}
    EEG = pop_editeventvals(EEG, 'delete', remove);
    %}
    
    % % %
    % % %  REREFERENCE the new dataset to the average reference
    % % %
    % moved rereference to before epoching b/c of discussion here: http://sccn.ucsd.edu/pipermail/eeglablist/2012/004650.html
    % it's possible this only applies if baseline is removed during epoching
    if reference
        EEG = pop_reref(EEG, []);
        EEG.comments = pop_comments(EEG.comments, '', 'Dataset was average refereced', 1);
        infoString = [infoString '_AVERAGE_REF'];
    end
    
    
    % % %
    % % %  SEGMENTATION
    % % %
    EEG = pop_epoch(EEG, {'DIN1', 'DIN2', 'DIN3', 'DIN4', 'DIN5', 'DIN6', 'DIN7', 'DIN8'}, ... % specification unnecessary b/c DIN0's already removed
        [startpoint, endpoint], 'setname', 'Continuous epochs', 'epochinfo', 'yes');
    
    
    %pop_saveset(EEG, 'filename', [setfilename 'filtered_continuous.set'], 'savemode', 'onefile');
    
    % % %
    % % %  BASELINING
    % % %
    if baseline
        EEG = pop_rmbase(EEG, [(startpoint*1000) 0]);
        EEG.comments = pop_comments(EEG.comments, '', ['Extracted ''DIN'' epochs [' num2str(startpoint*1000) ' 0] sec, and removed baseline.'], 1);
        
        % Now, either overwrite the parent dataset, if you don't need the continuous version any longer, or create a new dataset
        %(by removing the 'overwrite', 'on' option in the function call below).
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,  'setname', 'Continuous EEG Data epochs filtered');
        setfilename = strrep(eegfilename, '.raw' ,[infoString '_EPOCHED.set']);
        %pop_saveset(EEG,'filename',[setfilename '.set'],'savemode','onefile');
    end
    
    
    
    % % %
    % % % ARTIFACT REJECTION
    % % %
    %EEG = eeg_interp(EEG, 79);
    %[EEG ArtifactIndices] = pop_autorej(EEG, 'nogui', 'on');
    
    if strcmp(subj, 'p1')
        EEG = eeg_interp(EEG, 107);
        switch block
            case 1
                EEG = eeg_interp(EEG, 21);
            case 2
                EEG = eeg_interp(EEG, 21);
            case 3
                EEG = pop_editeventvals(EEG, 'delete', [71]);
            case 4
                EEG = pop_editeventvals(EEG, 'delete', [26, 54, 84]);
            case 5
                EEG = eeg_interp(EEG, 21);
                EEG = eeg_interp(EEG, 8);
                EEG = pop_editeventvals(EEG, 'delete', [5, 6, 76]);
            case 6
                EEG = pop_editeventvals(EEG, 'delete', [68, 70, 85]);
            case 7
                EEG = pop_editeventvals(EEG, 'delete', [26, 36, 38, 43, 54, 88, 91]);
            case 8
                EEG = pop_editeventvals(EEG, 'delete', [33, 36, 41, 51, 52, 55, 56]);
            case 9
                EEG = pop_editeventvals(EEG, 'delete', [33, 45, 47, 48, 49, 50, 51, 53, 61, 63]);
            case 10
                EEG = eeg_interp(EEG, 21);
                EEG = eeg_interp(EEG, 8);
                EEG = pop_editeventvals(EEG, 'delete', [63, 76]);
            otherwise
                disp('WARNING: block > 10')
        end
        disp('Interpolated and rejected for subj 1')
    end
    
    
    
    rejectartifacts = 1;
    if filtersettings(1, 1) == 0 && filtersettings(1, 2) == 0 && filtersettings(1, 3) == 0 && filtersettings(1, 4) == 0
        rejectartifacts = 0;
    end
    if rejectartifacts == 0;
        ArtifactIndices = [];
    elseif rejectartifacts
        eyeblinkchannels = 1:128;
        %threshold = 100;
        %change last parameter to 0 to not actually reject trials.
        %[EEG ArtifactIndices] = pop_eegthresh(EEG, 1, eyeblinkchannels, -threshold, threshold, -.2, 0.8, 1, 1);
        
        % Parameter update KM 7/13/18
        threshold = 75;
        [EEG ArtifactIndices] = pop_eegthresh(EEG, 1, eyeblinkchannels, -threshold, threshold, -.2, 0.2, 1, 1);
        
        % EEG = pop_rejepoch(EEG,ArtifactIndices,0);
        % [EEG locthresh globalthresh nrej] = pop_jointprob(EEG,1,eyeblinkchannels,4,4,'YES','YES','REJECTTRIALS');
        
        
        % Now, either overwrite the parent dataset, if you don't need the continuous version any longer, or create a new dataset
        %(by removing the 'overwrite', 'on' option in the function call below).
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,  'setname', 'Continuous EEG Data epochs baselined filtered artifacted');
    end
    
    % pop_saveset(EEG,'filename',[setfilename 'long_noRej.set'],'savemode','onefile');
    
    % Modify the dataset in the EEGLAB main window
    % [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); % Modify the dataset in the EEGLAB main window
    % eeglab redraw % Update the EEGLAB window to view changes
    
    % Save the EEG dataset structure
    processedeegfilename = strrep(eegfilename, 'long.raw', [infoString 'FINAL_EEGLAB_500hz']);
    pop_saveset(EEG, 'filename', [processedeegfilename  'allchans.set'], 'savemode', 'onefile');
    
    % ArtifactIndices = unique([ArtifactIndices, find(rejectindices)]);
    
    toc;
    
    end