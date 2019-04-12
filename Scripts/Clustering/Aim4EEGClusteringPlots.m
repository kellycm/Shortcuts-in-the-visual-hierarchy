%% WHICH ELECTRODES AND WHICH WINDOW?
% load('prepostuptrained_clustresults.mat','details','timepoint','elecvec')
% sigElecs = elecvec;
% %sigElecs = [58,65,66,68,69,70,73,81,82,84,88,89,90,94,96];
% window_start = 12;
% window_end = 76;

load('/Users/kellymartin/Desktop/Maxlab_CRCNS/PrePostLeft/prepostleft_allpost_clustresults.mat','details','timepoint','elecvec')
window_start = 24; %12;
window_end = 68;
sigElecs = elecvec;
WOI = (101:176); % 101:176 = 0-150ms
sigTimes = WOI(timepoint);

% load('prepostuptrained_clustresults.mat','timepoint','elecvec')
% sigElecs = elecvec;
% WOI = 101:176;
% window_start = (WOI(timepoint(1))-101)*2;
% window_end = (WOI(timepoint(end))-101)*2;

% Comparison name for output file
comparison = 'prepostleft_allpost';

% List of subjects to analyze
subj = {'p23','p26','p27','p28','p30','p31','p32','p34','p35','p38','p41'};

%% LOAD DATA
% Output of Aim4EEGClusteringPullIndividualSubjectData.m
% Pre
disp('Loading data for all conditions in pre...')
load('/Users/kellymartin/Desktop/Maxlab_CRCNS/all_preprocessed_CRCNS_data/pre_individual_conditions.mat')
pre_exptData = exptData;
clear exptData
disp('Done.')
% Post
disp('Loading data for all conditions in post...')
load('/Users/kellymartin/Desktop/Maxlab_CRCNS/all_preprocessed_CRCNS_data/post_individual_conditions.mat')
post_exptData = exptData;
clear exptData
disp('Done.')

% Conditions in exptData: 
% inv
% invleft
% invright
% invtrained
% invuntrained
% left
% lefttrained
% leftuntrained
% right
% righttrained
% rightuntrained
% trained
% untrained
% up
% upleft
% upright
% uptrained
% upuntrained

%% LOAD DATA FOR COMPARISON OF INTEREST FOR EACH SUBJECT && GET GROUP AVG

for s = 1:length(subj)
    
    % 1 pre up T
    % 2 post up T
    % 3 pre up U
    % 4 post up U
    % 5 pre inv T
    % 6 post inv T
    % 7 pre inv U
    % 8 post inv U
    
    % UPDATE THESE ANALYSIS-SPECIFIC CONTRASTS BEFORE RUNNING
    condition1 = pre_exptData(s).uptrained; % trials x timepoints x channels
    condition2 = post_exptData(s).uptrained; % trials x timepoints x channels
    condition3 = pre_exptData(s).upuntrained; % trials x timepoints x channels
    condition4 = post_exptData(s).upuntrained; % trials x timepoints x channels
    condition5 = pre_exptData(s).invtrained; % trials x timepoints x channels
    condition6 = post_exptData(s).invtrained; % trials x timepoints x channels
    condition7 = pre_exptData(s).invuntrained; % trials x timepoints x channels
    condition8 = post_exptData(s).invuntrained; % trials x timepoints x channels
    
    % Save the number of trials per subject per condition to graph later
    condition1_trials(s) = size(condition1,1); % value 0-240 per subject
    condition2_trials(s) = size(condition2,1); % value 0-240 per subject
    condition3_trials(s) = size(condition3,1); % value 0-240 per subject
    condition4_trials(s) = size(condition4,1); % value 0-240 per subject
    condition5_trials(s) = size(condition5,1); % value 0-240 per subject
    condition6_trials(s) = size(condition6,1); % value 0-240 per subject
    condition7_trials(s) = size(condition7,1); % value 0-240 per subject
    condition8_trials(s) = size(condition8,1); % value 0-240 per subject
    
    % average across all trials
    condition1_trialwiseavg(:,:,s) = mean(condition1,1); % timepoints x channels x subj
    condition2_trialwiseavg(:,:,s) = mean(condition2,1); % timepoints x channels x subj
    condition3_trialwiseavg(:,:,s) = mean(condition3,1); % timepoints x channels x subj
    condition4_trialwiseavg(:,:,s) = mean(condition4,1); % timepoints x channels x subj
    condition5_trialwiseavg(:,:,s) = mean(condition5,1); % timepoints x channels x subj
    condition6_trialwiseavg(:,:,s) = mean(condition6,1); % timepoints x channels x subj
    condition7_trialwiseavg(:,:,s) = mean(condition7,1); % timepoints x channels x subj
    condition8_trialwiseavg(:,:,s) = mean(condition8,1); % timepoints x channels x subj
    
    % within-condition avg per subj: avg across sig electrodes then trials
    withincond1_subjavgmat(:,s) = mean(mean(condition1(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond2_subjavgmat(:,s) = mean(mean(condition2(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond3_subjavgmat(:,s) = mean(mean(condition3(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond4_subjavgmat(:,s) = mean(mean(condition4(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond5_subjavgmat(:,s) = mean(mean(condition5(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond6_subjavgmat(:,s) = mean(mean(condition6(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond7_subjavgmat(:,s) = mean(mean(condition7(:,sigTimes,sigElecs),3),1); % timepoints x subj
    withincond8_subjavgmat(:,s) = mean(mean(condition8(:,sigTimes,sigElecs),3),1); % timepoints x subj
    
end

% across-condition avg per subj: cat withincond_subjavgmats, avg conditions
acrossprecond_subjavgmat(:,:,1) = withincond1_subjavgmat;
acrossprecond_subjavgmat(:,:,2) = withincond3_subjavgmat;
acrossprecond_subjavgmat(:,:,3) = withincond5_subjavgmat;
acrossprecond_subjavgmat(:,:,4) = withincond7_subjavgmat; % timepoints x subj x pre conditions
acrossprecond_subjavgmat = mean(acrossprecond_subjavgmat,3); % timepoints x subj

acrosspostcond_subjavgmat(:,:,1) = withincond2_subjavgmat;
acrosspostcond_subjavgmat(:,:,2) = withincond4_subjavgmat;
acrosspostcond_subjavgmat(:,:,3) = withincond6_subjavgmat;
acrosspostcond_subjavgmat(:,:,4) = withincond8_subjavgmat; % timepoints x subj x post conditions
acrosspostcond_subjavgmat = mean(acrosspostcond_subjavgmat,3); % timepoints x subj

% across-condition avg for group: avg all columns of acrosscond_subjavgmats
acrossprecond_groupavg = mean(acrossprecond_subjavgmat,2); % vector of 350 avg voltages
acrosspostcond_groupavg = mean(acrosspostcond_subjavgmat,2); % vector of 350 avg voltages

% compute within-subject SEM: (within-condition subj avg)-(across-condition subj avg)+(across-condition group avg)
% (within-cond subj avg - across-cond subj avg) +  across-cond group avg
cond1_withinsubjvar = (withincond1_subjavgmat-acrossprecond_subjavgmat)+acrossprecond_groupavg; % timepoints x subj
cond2_withinsubjvar = (withincond2_subjavgmat-acrossprecond_subjavgmat)+acrossprecond_groupavg; % timepoints x subj
cond3_withinsubjvar = (withincond3_subjavgmat-acrossprecond_subjavgmat)+acrossprecond_groupavg; % timepoints x subj
cond4_withinsubjvar = (withincond4_subjavgmat-acrossprecond_subjavgmat)+acrossprecond_groupavg; % timepoints x subj

cond5_withinsubjvar = (withincond5_subjavgmat-acrosspostcond_subjavgmat)+acrosspostcond_groupavg; % timepoints x subj
cond6_withinsubjvar = (withincond6_subjavgmat-acrosspostcond_subjavgmat)+acrosspostcond_groupavg; % timepoints x subj
cond7_withinsubjvar = (withincond7_subjavgmat-acrosspostcond_subjavgmat)+acrosspostcond_groupavg; % timepoints x subj
cond8_withinsubjvar = (withincond8_subjavgmat-acrosspostcond_subjavgmat)+acrosspostcond_groupavg; % timepoints x subj

% calc SEM
cond1_withinsubjSEM = std(cond1_withinsubjvar,0,2)/sqrt(length(subj));
cond2_withinsubjSEM = std(cond2_withinsubjvar,0,2)/sqrt(length(subj));
cond3_withinsubjSEM = std(cond3_withinsubjvar,0,2)/sqrt(length(subj));
cond4_withinsubjSEM = std(cond4_withinsubjvar,0,2)/sqrt(length(subj));

cond5_withinsubjSEM = std(cond5_withinsubjvar,0,2)/sqrt(length(subj));
cond6_withinsubjSEM = std(cond6_withinsubjvar,0,2)/sqrt(length(subj));
cond7_withinsubjSEM = std(cond7_withinsubjvar,0,2)/sqrt(length(subj));
cond8_withinsubjSEM = std(cond8_withinsubjvar,0,2)/sqrt(length(subj));

Aim4EEG_PostMinusPre_WithinSubjSEM(sigElecs,sigTimes,subj,withincond1_subjavgmat,withincond2_subjavgmat,withincond3_subjavgmat,withincond4_subjavgmat,withincond5_subjavgmat,withincond6_subjavgmat,withincond7_subjavgmat,withincond8_subjavgmat);


% % Set up Repeated measures model with rm_anova2 - post minus pre
% c21 = squeeze(mean(mean(condition2_trialwiseavg(sigTimes,sigElecs,:),2),1)-mean(mean(condition1_trialwiseavg(sigTimes,sigElecs,:),2),1));
% c43 = squeeze(mean(mean(condition4_trialwiseavg(sigTimes,sigElecs,:),2),1)-mean(mean(condition3_trialwiseavg(sigTimes,sigElecs,:),2),1));
% c65 = squeeze(mean(mean(condition6_trialwiseavg(sigTimes,sigElecs,:),2),1)-mean(mean(condition5_trialwiseavg(sigTimes,sigElecs,:),2),1));
% c87 = squeeze(mean(mean(condition8_trialwiseavg(sigTimes,sigElecs,:),2),1)-mean(mean(condition7_trialwiseavg(sigTimes,sigElecs,:),2),1));
% 
% V = cat(1,c21,c43,c65,c87);
% subjectvalues = (1:11)';
% S = cat(1,subjectvalues,subjectvalues,subjectvalues,subjectvalues); % col vec of 1:11 four times
% trained = ones(length(c21),1); % column vector of 1s
% untrained = ones(length(c43),1)+1; % column vector of 2s
% upright = ones(length(c21),1); % column vector of 1s
% inverted = ones(length(c65),1)+1; % column vector of 2s
% Position(1:11,1) = trained;
% Position(12:22,1) = untrained;
% Position(23:33,1) = trained;
% Position(34:44,1) = untrained;
% Orientation(1:11,1) = upright;
% Orientation(12:22,1) = upright;
% Orientation(23:33,1) = inverted;
% Orientation(34:44,1) = inverted;
% FACTNAMES = {'Position','Orientation'};
% stats = rm_anova2(V,S,Position,Orientation,FACTNAMES);

% Set up Repeated measures model with rm_anova2 - pre and post separated
c1 = squeeze(mean(mean(condition1_trialwiseavg(sigTimes,sigElecs,:),2),1));
c2 = squeeze(mean(mean(condition2_trialwiseavg(sigTimes,sigElecs,:),2),1));
c3 = squeeze(mean(mean(condition3_trialwiseavg(sigTimes,sigElecs,:),2),1));
c4 = squeeze(mean(mean(condition4_trialwiseavg(sigTimes,sigElecs,:),2),1));
c5 = squeeze(mean(mean(condition5_trialwiseavg(sigTimes,sigElecs,:),2),1));
c6 = squeeze(mean(mean(condition6_trialwiseavg(sigTimes,sigElecs,:),2),1));
c7 = squeeze(mean(mean(condition7_trialwiseavg(sigTimes,sigElecs,:),2),1));
c8 = squeeze(mean(mean(condition8_trialwiseavg(sigTimes,sigElecs,:),2),1));

VV = cat(1,c1,c2,c3,c4,c5,c6,c7,c8);
subjectvalues = (1:11)';
SS = cat(1,subjectvalues,subjectvalues,subjectvalues,subjectvalues,subjectvalues,subjectvalues,subjectvalues,subjectvalues);

% 1 pre up T
% 2 post up T
% 3 pre up U
% 4 post up U
% 5 pre inv T
% 6 post inv T
% 7 pre inv U
% 8 post inv U

oncond = ones(length(c1),1);
offcond = zeros(length(c1),1);

precode = cat(1,oncond,offcond,oncond,offcond,oncond,offcond,oncond,offcond);
postcode = cat(1,offcond,oncond,offcond,oncond,offcond,oncond,offcond,oncond)*2;
upcode = cat(1,oncond,oncond,oncond,oncond,offcond,offcond,offcond,offcond);
invcode = cat(1,offcond,offcond,offcond,offcond,oncond,oncond,oncond,oncond)*2;
trainedcode = cat(1,oncond,oncond,offcond,offcond,oncond,oncond,offcond,offcond);
untrainedcode = cat(1,offcond,offcond,oncond,oncond,offcond,offcond,oncond,oncond)*2;

Time = precode + postcode;
Orientation = upcode + invcode;
Position = trainedcode + untrainedcode;

anovamat = cat(2,VV,Time,Orientation,Position,SS);
[RMAOV33] = RMAOV33(anovamat);


%between = table(V,S,Position,Orientation,'VariableNames',{'AvgVolt','Subjects','Position','Orientation'});
%within = table(subjectvalues,c21,c43,c65,c87,'VariableNames',{'Subjects','C21','C43','C65','C87'});
%RM = fitrm(between,'AvgVolt ~ Position*Orientation','WithinDesign','Subjects');






% Plot voltage progression at each significant electrode? Separate plots
% for upright and inverted cars.
plotvolt_perelec = lower(input('Plot voltage progression at each electrode (y/n)?: '));
if strcmpi(plotvolt_perelec,'y')
    % haven't tested this function yet 1/3/19
    Aim4EEGSingleElecERPs(subj,sigElecs,condition1_groupavg,condition2_groupavg,condition3_groupavg,condition4_groupavg,condition1_trialwiseavg,condition2_trialwiseavg,condition3_trialwiseavg,condition4_trialwiseavg);
    Aim4EEGSingleElecERPs(subj,sigElecs,condition5_groupavg,condition6_groupavg,condition7_groupavg,condition8_groupavg,condition5_trialwiseavg,condition6_trialwiseavg,condition7_trialwiseavg,condition7_trialwiseavg);
end

% average across all subjects
condition1_groupavg = mean(condition1_trialwiseavg,3); % timepoints x channels
condition2_groupavg = mean(condition2_trialwiseavg,3); % timepoints x channels
condition3_groupavg = mean(condition3_trialwiseavg,3); % timepoints x channels
condition4_groupavg = mean(condition4_trialwiseavg,3); % timepoints x channels
condition5_groupavg = mean(condition5_trialwiseavg,3); % timepoints x channels
condition6_groupavg = mean(condition6_trialwiseavg,3); % timepoints x channels
condition7_groupavg = mean(condition7_trialwiseavg,3); % timepoints x channels
condition8_groupavg = mean(condition8_trialwiseavg,3); % timepoints x channels


%% PLOT DATA FOR COMPARISON OVER ELECTRODES OF INTEREST

% POST-PRE
% Upright trained
condition21_EOI = mean(condition2_groupavg(:,sigElecs),2)-mean(condition1_groupavg(:,sigElecs),2);
condition21_SEM = std((mean(condition2_trialwiseavg(:,sigElecs,:),2)-mean(condition1_trialwiseavg(:,sigElecs,:),2)),0,3)/sqrt(length(subj));

% Upright untrained
condition43_EOI = mean(condition4_groupavg(:,sigElecs),2)-mean(condition3_groupavg(:,sigElecs),2);
condition43_SEM = std((mean(condition4_trialwiseavg(:,sigElecs,:),2)-mean(condition3_trialwiseavg(:,sigElecs,:),2)),0,3)/sqrt(length(subj));

% Inverted trained
condition65_EOI = mean(condition6_groupavg(:,sigElecs),2)-mean(condition5_groupavg(:,sigElecs),2);
condition65_SEM = std((mean(condition6_trialwiseavg(:,sigElecs,:),2)-mean(condition5_trialwiseavg(:,sigElecs,:),2)),0,3)/sqrt(length(subj));

% Inverted untrained
condition87_EOI = mean(condition8_groupavg(:,sigElecs),2)-mean(condition7_groupavg(:,sigElecs),2);
condition87_SEM = std((mean(condition8_trialwiseavg(:,sigElecs,:),2)-mean(condition7_trialwiseavg(:,sigElecs,:),2)),0,3)/sqrt(length(subj));


% INDIVIDUAL POST AND PRE
% Upright pre trained
condition1_EOI = mean(condition1_groupavg(:,sigElecs),2); % timepoints x EOI
condition1_SEM = std(mean(condition1_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Upright post trained
condition2_EOI = mean(condition2_groupavg(:,sigElecs),2); % timepoints x EOI
condition2_SEM = std(mean(condition2_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Upright pre untrained
condition3_EOI = mean(condition3_groupavg(:,sigElecs),2); % timepoints x EOI
condition3_SEM = std(mean(condition3_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Upright post untrained
condition4_EOI = mean(condition4_groupavg(:,sigElecs),2); % timepoints x EOI
condition4_SEM = std(mean(condition4_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Inverted pre trained
condition5_EOI = mean(condition5_groupavg(:,sigElecs),2); % timepoints x EOI
condition5_SEM = std(mean(condition5_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Inverted post trained
condition6_EOI = mean(condition6_groupavg(:,sigElecs),2); % timepoints x EOI
condition6_SEM = std(mean(condition6_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Inverted pre untrained
condition7_EOI = mean(condition7_groupavg(:,sigElecs),2); % timepoints x EOI
condition7_SEM = std(mean(condition7_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));

% Inverted post untrained
condition8_EOI = mean(condition8_groupavg(:,sigElecs),2); % timepoints x EOI
condition8_SEM = std(mean(condition8_trialwiseavg(:,sigElecs,:),2),0,3)/sqrt(length(subj));


% cond1color = lower(input('Color for condition 1? ','s'));
% cond2color = lower(input('Color for condition 2? ','s'));
% cond3color = lower(input('Color for condition 3? ','s'));
% cond4color = lower(input('Color for condition 4? ','s'));
% cond5color = lower(input('Color for condition 5? ','s'));
% cond6color = lower(input('Color for condition 6? ','s'));
% cond7color = lower(input('Color for condition 7? ','s'));
% cond8color = lower(input('Color for condition 8? ','s'));

% cond1color = [0 1 1]; % cyan
% cond2color = [0 0.5 0.5]; % teal
% cond3color = [0 1 0]; % green
% cond4color = [0 0.5 0]; % dark green
% cond5color = [1 0 1]; % magenta
% cond6color = [0.5 0 0.5]; % purple
% cond7color = [1 0.8 0]; % dandelion
% cond8color = [1 0.5 0]; % orange

cond21color = [0 0 0]; % black
cond43color = [0.5 0.5 0.5]; % gray
cond65color = [1 0 1]; % magenta
cond87color = [1 0.7 1]; % light pink

% POST-PRE FOR UPRIGHT AND INVERTED, TRAINED VS. UNTRAINED
figure;
subplot(1,2,1)
errorbar(condition21_EOI,condition21_SEM,'c')
hold on
errorbar(condition43_EOI,condition43_SEM,'g')

timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 145 -1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Upright Cars'; [num2str(length(sigElecs)) ' Channels from All Trials Pre vs. Post Cluster']})
legend('Upright Trained','Upright Untrained')

subplot(1,2,2)
errorbar(condition65_EOI,condition65_SEM,'c')
hold on
errorbar(condition87_EOI,condition87_SEM,'g')

timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 145 -1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Inverted Cars'; [num2str(length(sigElecs)) ' Channels from All Trials Pre vs. Post Cluster']})
legend('Inverted Trained','Inverted Untrained')

% POST-PRE FOR TRAINED AND UNTRAINED, UPRIGHT VS. INVERTED
figure;
subplot(1,2,1)
errorbar(condition21_EOI,condition21_SEM,'k')
hold on
errorbar(condition65_EOI,condition65_SEM,'m')

timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 145 -1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Trained'; [num2str(length(sigElecs)) ' Channels from All Trials Pre vs. Post Cluster']})
legend('Upright Trained','Inverted Trained')

subplot(1,2,2)
errorbar(condition43_EOI,condition43_SEM,'k')
hold on
errorbar(condition87_EOI,condition87_SEM,'m')

timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 145 -1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Untrained'; [num2str(length(sigElecs)) ' Channels from All Trials Pre vs. Post Cluster']})
legend('Upright Untrained','Inverted Untrained')


%% ALL UPRIGHT (PRE POST TRAINED UNTRAINED) & ALL INVERTED (PRE POST TRAINED UNTRAINED)

% One figure with 4 subplots, comparing pre and post for each condition

cond1color = 'c'; % upright pre trained
cond2color = 'b'; % upright post trained
cond3color = 'g'; % upright pre untrained
cond4color = 'k'; % upright post untrained
cond5color = 'c'; % inverted pre trained
cond6color = 'b'; % inverted post trained
cond7color = 'g'; % inverted pre untrained
cond8color = 'k'; % inverted post untrained

% Pre vs. Post Upright Cars Trained
figure;
subplot(2,2,1)
errorbar(condition1_EOI,condition1_SEM,'Color',cond1color)
hold on
errorbar(condition2_EOI,condition2_SEM,'Color',cond2color)
timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 139 -3 3])
xlabel('Time (ms)')
ylabel('uV')
title({'Pre vs. Post Upright Cars'; [num2str(length(sigElecs)) ' Channels from Pre vs. Post Up Car Cluster']})
legend('Pre Trained','Post Trained','Location','NorthEast')

% Pre vs. Post Upright Cars Untrained
subplot(2,2,2)
errorbar(condition3_EOI,condition3_SEM,'Color',cond3color)
hold on
errorbar(condition4_EOI,condition4_SEM,'Color',cond4color)
timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 139 -3 3])
xlabel('Time (ms)')
ylabel('uV')
title({'Pre vs. Post Upright Cars'; [num2str(length(sigElecs)) ' Channels from Pre vs. Post Up Car Cluster']})
legend('Pre Untrained','Post Untrained','Location','NorthEast')

% Pre vs. Post Inverted Cars Trained
subplot(2,2,3)
errorbar(condition5_EOI,condition5_SEM,'Color',cond5color)
hold on
errorbar(condition6_EOI,condition6_SEM,'Color',cond6color)
timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 139 -3 3])
xlabel('Time (ms)')
ylabel('uV')
title({'Pre vs. Post Inverted Cars'; [num2str(length(sigElecs)) ' Channels from Pre vs. Post Up Car Cluster']})
legend('Pre Trained','Post Trained','Location','NorthEast')

% Pre vs. Post Inverted Cars Untrained
subplot(2,2,4)
errorbar(condition7_EOI,condition7_SEM,'Color',cond7color)
hold on
errorbar(condition8_EOI,condition8_SEM,'Color',cond8color)
timeTicks=[-200:6:500];
set(gca,'XTick',0:3:350,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
axis([105 139 -3 3])
xlabel('Time (ms)')
ylabel('uV')
title({'Pre vs. Post Inverted Cars'; [num2str(length(sigElecs)) ' Channels from Pre vs. Post Up Car Cluster']})
legend('Pre Untrained','Post Untrained','Location','NorthEast')

%% Bar Plots of Average Voltage in Cluster for Each Condition

condition21_subavgs = squeeze(mean(mean(condition2_trialwiseavg(:,sigElecs,:),2)-mean(condition1_trialwiseavg(:,sigElecs,:),2),1)); % average per subj
condition43_subavgs = squeeze(mean(mean(condition4_trialwiseavg(:,sigElecs,:),2)-mean(condition3_trialwiseavg(:,sigElecs,:),2),1));
condition65_subavgs = squeeze(mean(mean(condition6_trialwiseavg(:,sigElecs,:),2)-mean(condition5_trialwiseavg(:,sigElecs,:),2),1));
condition87_subavgs = squeeze(mean(mean(condition8_trialwiseavg(:,sigElecs,:),2)-mean(condition7_trialwiseavg(:,sigElecs,:),2),1));

% POST-PRE
% Upright trained
condition21_avgvolt = mean(mean(condition2_groupavg(:,sigElecs),2)-mean(condition1_groupavg(:,sigElecs),2)); % same as mean(condition21_EOI);
condition21_SEMvolt = std(mean(mean(condition2_trialwiseavg(:,sigElecs,:),2)-mean(condition1_trialwiseavg(:,sigElecs,:),2),1),0,3)/sqrt(length(subj));

% Upright untrained
condition43_avgvolt = mean(mean(condition4_groupavg(:,sigElecs),2)-mean(condition3_groupavg(:,sigElecs),2)); % same as mean(condition43_EOI);
condition43_SEMvolt = std(mean(mean(condition4_trialwiseavg(:,sigElecs,:),2)-mean(condition3_trialwiseavg(:,sigElecs,:),2),1),0,3)/sqrt(length(subj));

% Inverted trained
condition65_avgvolt = mean(mean(condition6_groupavg(:,sigElecs),2)-mean(condition5_groupavg(:,sigElecs),2)); % same as mean(condition65_EOI);
condition65_SEMvolt = std(mean(mean(condition6_trialwiseavg(:,sigElecs,:),2)-mean(condition5_trialwiseavg(:,sigElecs,:),2),1),0,3)/sqrt(length(subj));

% Inverted untrained
condition87_avgvolt = mean(mean(condition8_groupavg(:,sigElecs),2)-mean(condition7_groupavg(:,sigElecs),2)); % same as mean(condition87_EOI);
condition87_SEMvolt = std(mean(mean(condition8_trialwiseavg(:,sigElecs,:),2)-mean(condition7_trialwiseavg(:,sigElecs,:),2),1),0,3)/sqrt(length(subj));

figure;
bar(1,condition21_avgvolt,'FaceColor','c')
hold on
errorbar(1,condition21_avgvolt,condition21_SEMvolt,'k')
bar(2,condition43_avgvolt,'FaceColor','g')
errorbar(2,condition43_avgvolt,condition43_SEMvolt,'k')
bar(3,condition65_avgvolt,'FaceColor','c')
errorbar(3,condition65_avgvolt,condition65_SEMvolt,'k')
bar(4,condition87_avgvolt,'FaceColor','g')
errorbar(4,condition87_avgvolt,condition87_SEMvolt,'k')

set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'Up Trained','Up Untrained','Inv Trained','Inv Untrained'})
set(gca,'FontSize',13)
title({['Average Post-Pre Voltage Timecourse'];['in Post vs. Pre All Trials Cluster']})

% Regular One-Way ANOVA
anovamat(:,1)=mean(condition2_groupavg(:,sigElecs),2)-mean(condition1_groupavg(:,sigElecs),2); % post-pre up trained
anovamat(:,2)=mean(condition4_groupavg(:,sigElecs),2)-mean(condition3_groupavg(:,sigElecs),2); % post-pre up untrained
anovamat(:,3)=mean(condition6_groupavg(:,sigElecs),2)-mean(condition5_groupavg(:,sigElecs),2); % post-pre inv trained
anovamat(:,4)=mean(condition8_groupavg(:,sigElecs),2)-mean(condition7_groupavg(:,sigElecs),2); % post-pre inv untrained
[P,ANOVATAB,STATS] = anova1(anovamat,{'UpTrained','UpUntrained','InvTrained','InvUntrained'});
set(gca,'FontSize',13)
title('One Way ANOVA of Post-Pre in All Trials Pre vs. Post Cluster')

% Two-Factor Repeated Measures ANOVA (downloaded function from Mathworks)
condition21_subavgs = squeeze(mean(mean(condition2_trialwiseavg(:,sigElecs,:),2)-mean(condition1_trialwiseavg(:,sigElecs,:),2),1)); % average per subj
condition43_subavgs = squeeze(mean(mean(condition4_trialwiseavg(:,sigElecs,:),2)-mean(condition3_trialwiseavg(:,sigElecs,:),2),1));
condition65_subavgs = squeeze(mean(mean(condition6_trialwiseavg(:,sigElecs,:),2)-mean(condition5_trialwiseavg(:,sigElecs,:),2),1));
condition87_subavgs = squeeze(mean(mean(condition8_trialwiseavg(:,sigElecs,:),2)-mean(condition7_trialwiseavg(:,sigElecs,:),2),1));

V = cat(1,condition21_subavgs,condition43_subavgs,condition65_subavgs,condition87_subavgs);
subjectvalues = (1:11)';
S = cat(1,subjectvalues,subjectvalues,subjectvalues,subjectvalues); % col vec of 1:11 four times
trained = ones(length(condition21_subavgs),1); % column vector of 1s
untrained = ones(length(condition43_subavgs),1)+1; % column vector of 2s
upright = ones(length(condition21_subavgs),1); % column vector of 1s
inverted = ones(length(condition21_subavgs),1)+1; % column vector of 2s
Position(1:11,1) = trained;
Position(12:22,1) = untrained;
Position(23:33,1) = trained;
Position(34:44,1) = untrained;
Orientation(1:11,1) = upright;
Orientation(12:22,1) = upright;
Orientation(23:33,1) = inverted;
Orientation(34:44,1) = inverted;
FACTNAMES = {'Position','Orientation'};
RepeatedMeasuresStats = rm_anova2(V,S,Position,Orientation,FACTNAMES);
RepeatedMeasuresMat(:,1) = V;
RepeatedMeasuresMat(:,2) = S;
RepeatedMeasuresMat(:,3) = Position;
RepeatedMeasuresMat(:,4) = Orientation;

% These stats all look really weirdly strong 1/3/19
[~,P,CI,STATS]=ttest2(anovamat(:,1),anovamat(:,2)); % up trained vs. untrained
voltaverages.uptraineduntrained.p=P;
voltaverages.uptraineduntrained.CI=CI;
voltaverages.uptraineduntrained.stats=STATS;
[~,P,CI,STATS]=ttest2(anovamat(:,3),anovamat(:,4)); % inv trained vs. untrained
voltaverages.invtraineduntrained.p=P;
voltaverages.invtraineduntrained.CI=CI;
voltaverages.invtraineduntrained.stats=STATS;
[~,P,CI,STATS]=ttest2(anovamat(:,1),anovamat(:,3)); % up vs. inv trained
voltaverages.upinvtrained.p=P;
voltaverages.upinvtrained.CI=CI;
voltaverages.upinvtrained.stats=STATS;
[~,P,CI,STATS]=ttest2(anovamat(:,2),anovamat(:,4)); % up vs. inv untrained
voltaverages.upinvuntrained.p=P;
voltaverages.upinvuntrained.CI=CI;
voltaverages.upinvuntrained.stats=STATS;


%% Bar Plots of Average Number of Trials for Each Condition

figure;
bar(1,mean(condition1_trials),'FaceColor',cond1color)
hold on
bar(2,mean(condition2_trials),'FaceColor',cond2color)
bar(3,mean(condition3_trials),'FaceColor',cond3color)
bar(4,mean(condition4_trials),'FaceColor',cond4color)
bar(5,mean(condition5_trials),'FaceColor',cond5color)
bar(6,mean(condition6_trials),'FaceColor',cond6color)
bar(7,mean(condition7_trials),'FaceColor',cond7color)
bar(8,mean(condition8_trials),'FaceColor',cond8color)
errorbar(1,mean(condition1_trials),std(condition1_trials)/sqrt(length(subj)),'k');
errorbar(2,mean(condition2_trials),std(condition2_trials)/sqrt(length(subj)),'k');
errorbar(3,mean(condition3_trials),std(condition3_trials)/sqrt(length(subj)),'k');
errorbar(4,mean(condition4_trials),std(condition4_trials)/sqrt(length(subj)),'k');
errorbar(5,mean(condition5_trials),std(condition5_trials)/sqrt(length(subj)),'k');
errorbar(6,mean(condition6_trials),std(condition6_trials)/sqrt(length(subj)),'k');
errorbar(7,mean(condition2_trials),std(condition7_trials)/sqrt(length(subj)),'k');
errorbar(8,mean(condition8_trials),std(condition8_trials)/sqrt(length(subj)),'k');

set(gca,'XTick',[1:8])
set(gca,'XTickLabel',[])
set(gca,'YTick',[0:20:240])
set(gca,'YLim',[0,240]) % 240 possible trials per condition here
set(gca,'FontSize',13)
legend({'Pre Up T','Post Up T','Pre Up U','Post Up U','Pre Inv T','Post Inv T','Pre Inv U','Post Inv U'},'Location','southoutside','NumColumns',4)
title('Average Number of Trials Analyzed per Condition')

trialsanovamat(:,1) = condition1_trials;
trialsanovamat(:,2) = condition2_trials;
trialsanovamat(:,3) = condition3_trials;
trialsanovamat(:,4) = condition4_trials;
trialsanovamat(:,5) = condition5_trials;
trialsanovamat(:,6) = condition6_trials;
trialsanovamat(:,7) = condition7_trials;
trialsanovamat(:,8) = condition8_trials;
[P,ANOVATAB,STATS] = anova1(trialsanovamat,{'Pre Up T','Post Up T','Pre Up U','Post Up U','Pre Inv T','Post Inv T','Pre Inv U','Post Inv U'});
set(gca,'FontSize',13)
title('One Way ANOVA of Average Number of Trials Analyzed')


[~,P,CI,STATS]=ttest2(condition1_trials,condition2_trials);
trialaverages.prepostuptrained.p = P;
trialaverages.prepostuptrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition3_trials,condition4_trials);
trialaverages.prepostupuntrained.p = P;
trialaverages.prepostupuntrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition5_trials,condition6_trials);
trialaverages.prepostinvtrained.p = P;
trialaverages.prepostinvtrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition7_trials,condition8_trials);
trialaverages.prepostinvuntrained.p = P;
trialaverages.prepostinvuntrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition1_trials,condition3_trials);
trialaverages.preuptraineduntrained.p = P;
trialaverages.preuptraineduntrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition5_trials,condition7_trials);
trialaverages.preinvtraineduntrained.p = P;
trialaverages.preinvtraineduntrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition1_trials,condition5_trials);
trialaverages.preupinvtrained.p = P;
trialaverages.preupinvtrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition3_trials,condition7_trials);
trialaverages.preupinvuntrained.p = P;
trialaverages.preupinvuntrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition2_trials,condition6_trials);
trialaverages.postupinvtrained.p = P;
trialaverages.postupinvtrained.stats = STATS;
[~,P,CI,STATS]=ttest2(condition4_trials,condition8_trials);
trialaverages.postupinvuntrained.p = P;
trialaverages.postupinvuntrained.stats = STATS;

fprintf('\n %s \t p = %f \t t = %f %f \n','prepostuptrained',trialaverages.prepostuptrained.p,trialaverages.prepostuptrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','prepostupuntrained',trialaverages.prepostupuntrained.p,trialaverages.prepostupuntrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','prepostinvtrained',trialaverages.prepostinvtrained.p,trialaverages.prepostinvtrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','prepostinvuntrained',trialaverages.prepostinvuntrained.p,trialaverages.prepostinvuntrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','preuptraineduntrained',trialaverages.preuptraineduntrained.p,trialaverages.preuptraineduntrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','preinvtraineduntrained',trialaverages.preinvtraineduntrained.p,trialaverages.preinvtraineduntrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','preupinvtrained',trialaverages.preupinvtrained.p,trialaverages.preupinvtrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','preupinvuntrained',trialaverages.preupinvuntrained.p,trialaverages.preupinvuntrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','postupinvtrained',trialaverages.postupinvtrained.p,trialaverages.postupinvtrained.stats.tstat)
fprintf('\n %s \t p = %f \t t = %f %f \n','postupinvuntrained',trialaverages.postupinvuntrained.p,trialaverages.postupinvuntrained.stats.tstat)





% 1 pre up T
% 2 post up T
% 3 pre up U
% 4 post up U
% 5 pre inv T
% 6 post inv T
% 7 pre inv U
% 8 post inv U