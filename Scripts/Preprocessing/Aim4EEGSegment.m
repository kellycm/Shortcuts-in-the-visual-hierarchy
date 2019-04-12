function Aim4EEGSegment(subjectDir,subj,prepost)
%     subj = lower(input('Subject name >> ', 's'));
%     pre = lower(input('Pre-training? (y/n) >> ', 's'));
%     if isequal(pre, 'y')
%         prepost = 'pre';
%     else
%         prepost = 'post';
%     end
    %parentDir = [subj filesep subj prepost 'EEG' filesep];
%    parentDir = ['/home/kelly/Desktop/subjects/' subj '/' prepost '/'];
     %subjectDir = ['/home/kelly/Desktop/subjects/' subj '/' prepost '/allchans/'];
%     %directory = [subj filesep subj prepost 'EEG' filesep 'preprocessed' filesep];
%     directory = parentDir;
    %setfiles = dir([directory '*.set']);
    cd(subjectDir)
%     cd(directory)
    setfiles = dir('*.set');
    
    mkdir([subjectDir 'segmented']);
    
    startpoint = -0.2;
    endpoint = 0.5;
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset([subjectDir setfiles(1).name]);
    for f = 2:length(setfiles)
        EEGcurr = pop_loadset([subjectDir setfiles(f).name]);
        EEG = pop_mergeset(EEG, EEGcurr);
    end
    
    % % %
    % % %  SEGMENTATION specific to Aim4 CRCNS
    % % %
    
    if strcmp(subj,'p22') || strcmp(subj,'p26') || strcmp(subj,'p28') || strcmp(subj,'p32') || strcmp(subj,'p34') || strcmp(subj,'p38') || strcmp(subj,'p41')
        
        % Group1/L-trained
        
        fprintf('1: right, untrained, up\n 2: right, untrained, inv\n 3: right, trained, up\n 4: right, trained, inv\n 5: left, untrained, up\n 6: left, untrained, inv\n 7: left, trained, up\n 8: left, trained, inv\n')
        
        EEGup = pop_epoch(EEG, {'DIN1', 'DIN3', 'DIN5', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars', 'epochinfo', 'yes');
        pop_saveset(EEGup, 'filename', [subj prepost 'up'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinv = pop_epoch(EEG, {'DIN2', 'DIN4', 'DIN6', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars', 'epochinfo', 'yes');
        pop_saveset(EEGinv, 'filename', [subj prepost 'inv'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGtrained = pop_epoch(EEG, {'DIN3', 'DIN4', 'DIN7', 'DIN8'}, [startpoint, endpoint], 'setname', 'TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGtrained, 'filename', [subj prepost 'trained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGuntrained = pop_epoch(EEG, {'DIN1', 'DIN2', 'DIN5', 'DIN6'}, [startpoint, endpoint], 'setname', 'UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGuntrained, 'filename', [subj prepost 'untrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGright = pop_epoch(EEG, {'DIN1', 'DIN2', 'DIN3', 'DIN4'}, [startpoint, endpoint], 'setname', 'RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGright, 'filename', [subj prepost 'right'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGleft = pop_epoch(EEG, {'DIN5', 'DIN6', 'DIN7', 'DIN8'}, [startpoint, endpoint], 'setname', 'LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGleft, 'filename', [subj prepost 'left'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupTrained = pop_epoch(EEG, {'DIN3', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGupTrained, 'filename', [subj prepost 'upTrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvTrained = pop_epoch(EEG, {'DIN4', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGinvTrained, 'filename', [subj prepost 'invTrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupUntrained = pop_epoch(EEG, {'DIN1', 'DIN5'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGupUntrained, 'filename', [subj prepost 'upUntrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvUntrained = pop_epoch(EEG, {'DIN2', 'DIN6'}, [startpoint, endpoint], 'setname', 'INVERTED cars UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGinvUntrained, 'filename', [subj prepost 'invUntrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupRight = pop_epoch(EEG, {'DIN1', 'DIN3'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGupRight, 'filename', [subj prepost 'upRight'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGupLeft = pop_epoch(EEG, {'DIN5', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGupLeft, 'filename', [subj prepost 'upLeft'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGinvRight = pop_epoch(EEG, {'DIN2', 'DIN4'}, [startpoint, endpoint], 'setname', 'INVERTED cars RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGinvRight, 'filename', [subj prepost 'invRight'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvLeft = pop_epoch(EEG, {'DIN6', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGinvLeft, 'filename', [subj prepost 'invLeft'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
    elseif strcmp(subj,'p23') || strcmp(subj,'p25') || strcmp(subj,'p27') || strcmp(subj,'p30') || strcmp(subj,'p31') || strcmp(subj,'p33') || strcmp(subj,'p35')
        
        % Group2/R-trained
        
        fprintf('1: right, trained, up\n 2: right, trained, inv\n 3: right, untrained, up\n 4: right, untrained, inv\n 5: left, trained, up\n 6: left, trained, inv\n 7: left, untrained, up\n 8: left, untrained, inv\n')
        
        EEGup = pop_epoch(EEG, {'DIN1', 'DIN3', 'DIN5', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars', 'epochinfo', 'yes');
        pop_saveset(EEGup, 'filename', [subj prepost 'up'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinv = pop_epoch(EEG, {'DIN2', 'DIN4', 'DIN6', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars', 'epochinfo', 'yes');
        pop_saveset(EEGinv, 'filename', [subj prepost 'inv'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGtrained = pop_epoch(EEG, {'DIN1', 'DIN2', 'DIN5', 'DIN6'}, [startpoint, endpoint], 'setname', 'TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGtrained, 'filename', [subj prepost 'trained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGuntrained = pop_epoch(EEG, {'DIN3', 'DIN4', 'DIN7', 'DIN8'}, [startpoint, endpoint], 'setname', 'UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGuntrained, 'filename', [subj prepost 'untrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGright = pop_epoch(EEG, {'DIN1', 'DIN2', 'DIN3', 'DIN4'}, [startpoint, endpoint], 'setname', 'RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGright, 'filename', [subj prepost 'right'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGleft = pop_epoch(EEG, {'DIN5', 'DIN6', 'DIN7', 'DIN8'}, [startpoint, endpoint], 'setname', 'LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGleft, 'filename', [subj prepost 'left'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupTrained = pop_epoch(EEG, {'DIN1', 'DIN5'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGupTrained, 'filename', [subj prepost 'upTrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvTrained = pop_epoch(EEG, {'DIN2', 'DIN6'}, [startpoint, endpoint], 'setname', 'INVERTED cars TRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGinvTrained, 'filename', [subj prepost 'invTrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupUntrained = pop_epoch(EEG, {'DIN3', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGupUntrained, 'filename', [subj prepost 'upUntrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvUntrained = pop_epoch(EEG, {'DIN4', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars UNTRAINED locs', 'epochinfo', 'yes');
        pop_saveset(EEGinvUntrained, 'filename', [subj prepost 'invUntrained'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGupRight = pop_epoch(EEG, {'DIN1', 'DIN3'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGupRight, 'filename', [subj prepost 'upRight'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGupLeft = pop_epoch(EEG, {'DIN5', 'DIN7'}, [startpoint, endpoint], 'setname', 'UPRIGHT cars LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGupLeft, 'filename', [subj prepost 'upLeft'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
        EEGinvRight = pop_epoch(EEG, {'DIN2', 'DIN4'}, [startpoint, endpoint], 'setname', 'INVERTED cars RIGHT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGinvRight, 'filename', [subj prepost 'invRight'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        EEGinvLeft = pop_epoch(EEG, {'DIN6', 'DIN8'}, [startpoint, endpoint], 'setname', 'INVERTED cars LEFT hemi', 'epochinfo', 'yes');
        pop_saveset(EEGinvLeft, 'filename', [subj prepost 'invLeft'] , 'filepath', [subjectDir 'segmented' filesep], 'savemode', 'onefile');
        
    else disp('subject ID incorrect')
        
    end
    
end