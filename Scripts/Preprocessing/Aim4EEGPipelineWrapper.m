function Aim4EEGPipelineWrapper
% Preprocess all subjects for pre or post
%% Setup
scriptDir = '/home/kelly/Desktop/Rotation';

pre = lower(input('Pre-training? (y/n) >> ', 's'));
if isequal(pre, 'y')
    prepost = 'pre';
    subj = {'p22','p23','p25','p26','p27','p28','p30','p31','p32','p33','p34','p35','p38','p41'};
else
    prepost = 'post';
    subj = {'p23','p26','p27','p28','p30','p31','p32','p34','p35','p38','p41'};
end

%% Loop through all subjects
for s = 1:length(subj)
    
    switch prepost
        case 'pre'
            if strcmp(subj{s},'p22') || strcmp(subj{s},'p31') || strcmp(subj{s},'p33')
                subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/goodblocks/'];
                %subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/goodblocks/allchans_0.4/'];
            else
                subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/'];
                %subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans_0.4/'];
            end
        case 'post'
            if strcmp(subj{s},'p26') || strcmp(subj{s},'p35')
                subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/goodblocks/'];
                %subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/goodblocks/allchans_0.4/'];
            else
                subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans/'];
                %subjectDir = ['/home/kelly/Desktop/subjects/' subj{s} '/' prepost '/allchans_0.4/'];
            end
    end
    
    %% 1. Generate list of automatically rejected channels per sub   
    disp('1. Detecting bad channels...')

    [badChan]=EEGPreProc2(subjectDir,subj{s},prepost,0.1,30,'sep',0,1);
    % Make sure you have 'Hydrocel_GSN_128_1.0_TRIM_mod.sfp' file

    disp('Finished detecting bad channels.')
    
    %% 2. Binarize list of bad channels per sub
    disp('2. Making binarized list of bad channels...')

    electrodes = [1:128];
    badChanMatrix = zeros(length(electrodes),1);
    
    for b = 1:length(badChan)
        badChanMatrix(badChan{b},s)=1;
    end        
    
    cd(subjectDir)
    save('chanData.mat','subj','badChanMatrix');
    
    disp('Binarized list of bad channels saved to subject folder.')
    cd(scriptDir)
    
    %% 3. Preprocess data
    disp('3. Preprocessing data...')
    
    [eegdata EEG] = Aim4EEGPreprocessAllData(subjectDir,subj{s},badChan);
    
    disp('Finished preprocessing data.')
    cd(scriptDir)
    
    %% 4. Segment data
    disp('4. Segmenting data...')
    
    Aim4EEGSegment(subjectDir,subj{s},prepost);
    
    disp('Finished segmenting data.')
    cd(scriptDir)
    
    %% 5. Timelock indiv sub data
    disp('5. Timelocking each condition...')
    
    cd([subjectDir '/segmented'])
    setfiles=dir('*.set');
    
    ft_defaults;
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    cfg = [];
    data = {};
    
    for group = 1:length(setfiles)
        
        EEG = pop_loadset([subjectDir '/segmented/' setfiles(group).name]);
        setfiles(group).name
        ftEEG = eeglab2fieldtrip(EEG, 'preprocessing');
        save([subjectDir setfiles(group).name(1:end - 4)], 'ftEEG');
        data(group).tl = ft_timelockanalysis(cfg, ftEEG);
        if isequal(prepost, 'pre')
            data(group).name = ['pre' setfiles(group).name(7:end - 4)];
        else
            data(group).name = ['post' setfiles(group).name(8:end - 4)];
        end
    end
    
    disp('Finished timelocking each condition.')
    
    %% 6. Separate data for each condition across all subs
    disp('6. Parsing conditions for all subs...')
    
    switch prepost
        case 'pre'
            
            preinv(s).data = data(1).tl;
            
            preinvLeft(s).data = data(2).tl;
            
            preinvRight(s).data = data(3).tl;
            
            preinvTrained(s).data = data(4).tl;
            
            preinvUntrained(s).data = data(5).tl;
            
            preleft(s).data = data(6).tl;
            
            preright(s).data = data(7).tl;
            
            pretrained(s).data = data(8).tl;
            
            preuntrained(s).data = data(9).tl;
            
            preup(s).data = data(10).tl;
            
            preupLeft(s).data = data(11).tl;
            
            preupRight(s).data = data(12).tl;
            
            preupTrained(s).data = data(13).tl;
            
            preupUntrained(s).data = data(14).tl;
            
            disp('Finished parsing conditions.')
            
            cd(scriptDir)
            
            save('Aim4GroupPre_causal.mat','preinv','preinvLeft','preinvRight',...
                'preinvTrained','preinvUntrained','preleft','preright','pretrained',...
                'preuntrained','preup','preupLeft','preupRight','preupTrained',...
                'preupUntrained')
            
        case 'post'
            
            postinv(s).data = data(1).tl;
            
            postinvLeft(s).data = data(2).tl;
            
            postinvRight(s).data = data(3).tl;
            
            postinvTrained(s).data = data(4).tl;
            
            postinvUntrained(s).data = data(5).tl;
            
            postleft(s).data = data(6).tl;
            
            postright(s).data = data(7).tl;
            
            posttrained(s).data = data(8).tl;
            
            postuntrained(s).data = data(9).tl;
            
            postup(s).data = data(10).tl;
            
            postupLeft(s).data = data(11).tl;
            
            postupRight(s).data = data(12).tl;
            
            postupTrained(s).data = data(13).tl;
            
            postupUntrained(s).data = data(14).tl;
            
            disp('Finished parsing conditions.')
            
            cd(scriptDir)
            
            save('Aim4GroupPost_causal.mat','postinv','postinvLeft','postinvRight',...
                'postinvTrained','postinvUntrained','postleft','postright','posttrained',...
                'postuntrained','postup','postupLeft','postupRight','postupTrained',...
                'postupUntrained')
            
    end
end

keyboard


%% 7. Grand timelock average group data -- DON'T RUN THIS. Weird Results.
% 
% disp('7. Timelock averaging group data...')
% 
% % 1
% [preinv_grandavg] = ft_timelockgrandaverage(cfg, preinv.data);
% % 2
% [preinvLeft_grandavg] = ft_timelockgrandaverage(cfg, preinvLeft.data);
% % 3
% [preinvRight_grandavg] = ft_timelockgrandaverage(cfg, preinvRight.data);
% % 4
% [preinvTrained_grandavg] = ft_timelockgrandaverage(cfg, preinvTrained.data);
% % 5
% [preinvUntrained_grandavg] = ft_timelockgrandaverage(cfg, preinvUntrained.data);
% % 6
% [preleft_grandavg] = ft_timelockgrandaverage(cfg, preleft.data);
% % 7
% [preright_grandavg] = ft_timelockgrandaverage(cfg, preright.data);
% % 8
% [pretrained_grandavg] = ft_timelockgrandaverage(cfg, pretrained.data);
% % 9
% [preuntrained_grandavg] = ft_timelockgrandaverage(cfg, preuntrained.data);
% % 10
% [preup_grandavg] = ft_timelockgrandaverage(cfg, preup.data);
% % 11
% [preupLeft_grandavg] = ft_timelockgrandaverage(cfg, preupLeft.data);
% % 12
% [preupRight_grandavg] = ft_timelockgrandaverage(cfg, preupRight.data);
% % 13
% [preupTrained_grandavg] = ft_timelockgrandaverage(cfg, preupTrained.data);
% % 14
% [preupUntrained_grandavg] = ft_timelockgrandaverage(cfg, preupUntrained.data);

% save('Aim4GroupPre.mat','preinv_grandavg','preinvLeft_grandavg',...
%     'preinvRight_grandavg','preinvTrained_grandavg','preinvUntrained_grandavg',...
%     'preleft_grandavg','preright_grandavg','pretrained_grandavg',...
%     'preuntrained_grandavg','preup_grandavg','preupLeft_grandavg',...
%     'preupRight_grandavg','preupTrained_grandavg','preupUntrained_grandavg',...
%     'data');
% 
% disp('Finished timelock averaging group data.')
% 
% keyboard
%% Plot Results

plotdata = lower(input('Plot data? (y/n) >> ', 's'));

if isequal(plotdata,'y')
    Aim4EEGPlotWrapper()
end

%% Plot percentage of bad occipital electrodes per subject

plotbadelec = lower(input('Plot bad electrodes? (y/n) >> ', 's'));

if iesequal(plotbadelec,'y')
    Aim4PlotBadElectrodes(prepost,subj)
end

end