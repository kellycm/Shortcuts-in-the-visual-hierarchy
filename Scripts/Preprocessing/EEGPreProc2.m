function [badChan] = EEGPreProc2(subjectDir,subj,prepost,highPass,lowPass,filtMeth,causal,reref)
% EEG Filtering function. SD, KCM edited 1/26/18
% prepost: string, 'pre', 'post', or []
% highPass: scalar, higher edge of frequency pass band (Hz)
% lowPass: scalar, lower edge of frequency pass band (Hz)
% filtMeth: string, 'sep' for high then low (recommended),'bp' for bandpass
% causal: logical/boolean, min-phase converted causal filter
% reref: logical/boolean, rereference to average ref
% example:
% EEGPreProc2('pre',0.1,30,'sep',0,1)
% EEGPreProc2(subjectDir,subj{1},0.1,30,'sep',0,1)

% To debug:
% prepost='pre';highPass=0.1;lowPass=30;filtMeth='sep';causal=0;reref=1;subjectDir = '/home/kelly/Desktop/subjects';subj={'p22'};
%% Set subject directory path
%subjectDir = '/home/kelly/Desktop/subjects';

%S = dir(subjectDir); % struct w/ subIDs in name field, first 2 are . & ..
%subj = {S(3:end).name}; % 1xn cell array of subject IDs

%If you want to run just one subject; also change parfor to for
%subj = {'p21'};

%% PREPROCESS

%for s = 1:length(subj) %parallelized forloop
    
    % Set raw data dir path, including pre & post folders if relevant
%     if strcmp(prepost,'pre')||strcmp(prepost,'post')
%         rawDataDir = [subjectDir '/' subj{s} '/' prepost];
%     else
%         rawDataDir = [subjectDir '/' subj{s}];
%     end
    
    % Confirm data dir exists, if so run analysis. If not print message
    if exist(subjectDir,'dir')
        
        % Set or create preproc dir (in pre/post folder if relevant)
        preProcDir = [subjectDir '/preprocessed'];
        
        if ~exist(preProcDir,'dir')
            mkdir(preProcDir)
        end
        
        % Set or create FT (fieldtrip) & ELab (EEGLab) subdirs in preProcDir
        %preProcFT = fullfile(preProcDir,'FT');
        preProcELab = fullfile(preProcDir,'ELab');
        
        if ~exist(preProcELab,'dir')
            mkdir(preProcELab)
        end
        
%         if ~exist(preProcFT,'dir')
%             mkdir(preProcFT)
%         end
%         
        % Now move into raw data dir for analysis
        cd(subjectDir)
        
        Blocks = dir('*.raw'); % Blocks.name contains all rawdata files/blocks
        %nBlocks = length(Blocks); % # experiment blocks/rawdata files
        
        data = [];
        trialInfo = [];
        badChan = [];
        
        counter = 0;
        
        for i = 1:length(Blocks)
            
            counter = counter+1;
            
            %load in data set
            dataPath = [subjectDir '/' Blocks(i).name];
            
            elecFile = which('Hydrocel_GSN_128_1.0_TRIM_mod.sfp'); % need this file
            
            EEG = pop_readegi(dataPath); 
            EEG = pop_chanedit(EEG, 'load',{elecFile 'filetype' 'autodetect'});
            
            switch filtMeth
                case 'bp' %bandpass filter
                    EEG = pop_eegfiltnew(EEG, highPass,lowPass,[],0,0,0,causal);
                case 'sep'% first high-pass and then low-pass. This is better!
                    EEG = pop_eegfiltnew(EEG, highPass,0,[],0,0,0,causal);
                    EEG = pop_eegfiltnew(EEG, 0,lowPass,[],0,0,0,causal);
            end
           
            % Use clean_rawdata to identify bad electrodes
            originalEEG = EEG;
            
            % stricter rejection threshold (0.8):
            EEG = clean_rawdata(EEG, [], -1, [], [], 20, []);
            
            % looser rejection threshold:
            %EEG = clean_rawdata(EEG, [], -1, 0.4, [], 20, []);
            
            badChannels = find(~EEG.etc.clean_channel_mask);
            badChan{i} = badChannels;
            
            % reinterpolate bad electrodes
            EEG = pop_select(originalEEG, 'nochannel', badChannels);
            EEG = pop_interp(EEG,originalEEG.chanlocs,'spherical');
            
            %Epoch data and remove baseline
            EEG = pop_epoch( EEG, {'DIN'}, [-.2 .7]);
            EEG = pop_rmbase( EEG, [-200    -2]);
            
            %Artifact detection using all channels and a threshold of -75 to 75
            [EEG, Indexes] = pop_eegthresh(EEG, 1, 1:128, -75, 75, -.2, .7, 0,0);
            EEG2 = pop_eegthresh(EEG, 1, 1:128, -75, 75, -.2, .7, 0,1);
            
            goodTrials = true(size(EEG.event));
            goodTrials(Indexes) = false;
            
            % Re-reference to average reference scheme using good trials only
            if reref
                EEG2.nbchan = EEG2.nbchan+1;
                EEG2.data(end+1,:,:) = zeros(1, EEG2.pnts,size(EEG2.data,3));
                EEG2.chanlocs(1,EEG2.nbchan).labels = 'initialReference';
                EEG2 = pop_reref(EEG2, []);
                EEG2 = pop_select( EEG2,'nochannel',{'initialReference'});
            end
            
            %replace non-average referenced data with average reference data
            EEG.data(:,:,goodTrials) = EEG2.data;
            
            %concatenate good trials and data across runs
            trialInfo = cat(2,trialInfo,goodTrials); % keeps track of which trials are artifact trials and which ones are good
            data = cat(3,data,EEG.data);
            
            %Uncomment to save each block as its own .mat file
            %blockDataFile = fullfile(preProcELab,sprintf('Subject_%s_%.1f_%d_%s_%d_%d_%d.mat',subj{s},highPass,lowPass,filtMeth,causal,reref,counter));
            blockDataFile = fullfile(preProcELab,sprintf('Subject_%s_%.1f_%d_%s_%d_%d_%d.mat',subj,highPass,lowPass,filtMeth,causal,reref,counter));
            parsave(blockDataFile,EEG.data,goodTrials,badChan);

        end
        
        %dataFile1 = fullfile(preProcELab,sprintf('Subject_%s_%.1f_%d_%s_%d_%d.mat',subj{s},highPass,lowPass,filtMeth,causal,reref));
        dataFile1 = fullfile(preProcELab,sprintf('Subject_%s_%.1f_%d_%s_%d_%d.mat',subj,highPass,lowPass,filtMeth,causal,reref));
        parsave(dataFile1,data,trialInfo,badChan);
        
    else
        fprintf('No %s dir for subject %s\n',prepost,subj);
    end
%end

end

function parsave(fname,data,trialInfo,badChan)
% subfunction to permit saving file, "save" can't be used w/ parfor
save(fname,'data','trialInfo','badChan')
end
