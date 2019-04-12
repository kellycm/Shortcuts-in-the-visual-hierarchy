
% % Run this to get the significant electrodes at each timepoint in cluster:
% timepoint = min(clusterIdx{1,1}(:,2)):max(clusterIdx{1,1}(:,2));
% % e.g., 33 timeponts from 7 to 39 (which is 12 to 76ms if WOI is 0:150)
% 
% % Make a cell array of t cells, each cell containing all electrodes in
% % clusterIdx{1,1}(:,1) for a given timepoint
% for t = 1:length(timepoint)
%     idx = find(clusterIdx{1,1}(:,2)==timepoint(t));
%     temp{t} = clusterIdx{1,1}(idx,1);
% end
% 
% elecvec = EOI(unique(clusterIdx{1}(:,1)));
% 
% details.cdf = 0.01;
% details.elecneighborhood = '4cm';
% details.WOI = '0-150ms';
% details.EOI = 'all posterior';
% details.sigelecs = temp;
% 
% save('prepost_clustresults.mat','details','timepoint','elecvec')
% 
% clear('details','elecvec','timepoint','temp','t')


% sigE_x_sigT = one cell per timepoint containing sig electrodes in cluster

% for each subject:
% V_x_sigT = avg voltage of each cell in sigE_x_sigT (array of doubles)
% sub_avgVinClust = avg across V_x_sigT
% sub_SEMVinClust = SEM across V_x_sigT

% across subjects:
% group_avgVinClust = avg across sub_avgVinClust
% group_SEMVinClust = SEM across sub_SEMV_inClust

load('prepost_clustresults.mat','details','timepoint','elecvec')
sigE = elecvec;
sigT = timepoint;
sigE_x_sigT = details.sigelecs;

subj = {'p23','p26','p27','p28','p30','p31','p32','p34','p35','p38','p41'};

% Output of Aim4EEGClusteringPullIndividualSubjectData.m
% Pre
disp('Loading data for all conditions in pre...')
load('pre_individual_conditions.mat')
pre_exptData = exptData;
clear exptData
disp('Done.')
% Post
disp('Loading data for all conditions in post...')
load('post_individual_conditions.mat')
post_exptData = exptData;
clear exptData
disp('Done.')

% for each subject:

% Pull data:
% pre up trained, up untrained, inv trained, and inv untrained
% post up trained, up untrained, inv trained, and inv untrained

% Compute:
% V_x_sigT = avg voltage of each cell in sigE_x_sigT (array of doubles)

plotindsubj = lower(input('Plot individual subject ERPs? (y/n): ','s'));

for s = 1:length(subj)
    
    % Pull data
    % trials x timepoints x channels x subjects (n x 350 x 128 x 11)
    pre_up_T = pre_exptData(s).uptrained;
    pre_up_U = pre_exptData(s).upuntrained;
    pre_inv_T = pre_exptData(s).invtrained;
    pre_inv_U = pre_exptData(s).invuntrained;
    
    post_up_T = post_exptData(s).uptrained;
    post_up_U = post_exptData(s).upuntrained;
    post_inv_T = post_exptData(s).invtrained;
    post_inv_U = post_exptData(s).invuntrained;
    
    % avg all trials = timepoints x channels x subjects (350 x 128 x 11)
    pre_up_T_trialwiseavg(:,:,s) = mean(pre_up_T,1);
    pre_up_U_trialwiseavg(:,:,s) = mean(pre_up_U,1);
    pre_inv_T_trialwiseavg(:,:,s) = mean(pre_inv_T,1);
    pre_inv_U_trialwiseavg(:,:,s) = mean(pre_inv_U,1);
    post_up_T_trialwiseavg(:,:,s) = mean(post_up_T,1);
    post_up_U_trialwiseavg(:,:,s) = mean(post_up_U,1);
    post_inv_T_trialwiseavg(:,:,s) = mean(post_inv_T,1);
    post_inv_U_trialwiseavg(:,:,s) = mean(post_inv_U,1);
    
    for t = 1:length(sigE_x_sigT)
        
        % average across sig electrodes at each timepoint
        % 11 x 33 matrix of voltages at each timepoint in cluster per subj
        pre_up_T_V_x_sigT(s,t) = mean(pre_up_T_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        pre_up_U_V_x_sigT(s,t) = mean(pre_up_U_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        pre_inv_T_V_x_sigT(s,t) = mean(pre_inv_T_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        pre_inv_U_V_x_sigT(s,t) = mean(pre_inv_U_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        post_up_T_V_x_sigT(s,t) = mean(post_up_T_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        post_up_U_V_x_sigT(s,t) = mean(post_up_U_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        post_inv_T_V_x_sigT(s,t) = mean(post_inv_T_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        post_inv_U_V_x_sigT(s,t) = mean(post_inv_U_trialwiseavg(sigT(t),sigE_x_sigT{t},s),2);
        
    end
    
    if strcmpi(plotindsubj,'y')
        %Plot all 33 timepoints for all 11 subjects for all 8 conditions
        figure(1)
        
        subplot(2,4,1)
        plot(pre_up_T_V_x_sigT(s,:))
        hold on
        title('Pre Upright Trained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        subplot(2,4,2)
        plot(post_up_T_V_x_sigT(s,:))
        hold on
        title('Post Upright Trained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,3)
        plot(pre_inv_T_V_x_sigT(s,:))
        hold on
        title('Pre Inverted Trained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,4)
        plot(post_inv_T_V_x_sigT(s,:))
        hold on
        title('Post Inverted Trained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,5)
        plot(pre_up_U_V_x_sigT(s,:))
        hold on
        title('Pre Upright Untrained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,6)
        plot(post_up_U_V_x_sigT(s,:))
        hold on
        title('Post Upright Untrained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,7)
        plot(pre_inv_U_V_x_sigT(s,:))
        hold on
        title('Pre Inverted Untrained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
        
        
        subplot(2,4,8)
        plot(post_inv_U_V_x_sigT(s,:))
        hold on
        title('Post Inverted Untrained')
        axis([0 33 -2.6 1.5])
        set(gca,'XTick',[1:10:33])
        set(gca,'XTickLabel',[12:20:76])
        xlabel('Time (s)')
        ylabel('uV')
    end
    
end

%% CALCULATE POST-PRE FOR EACH SUBJECT AT EACH TIMEPOINT
change_up_T_V_x_sigT = mean(post_up_T_V_x_sigT,1)-mean(pre_up_T_V_x_sigT,1);
change_up_U_V_x_sigT = mean(post_up_U_V_x_sigT,1)-mean(pre_up_U_V_x_sigT,1);
change_inv_T_V_x_sigT = mean(post_inv_T_V_x_sigT,1)-mean(pre_inv_T_V_x_sigT,1);
change_inv_U_V_x_sigT = mean(post_inv_U_V_x_sigT,1)-mean(pre_inv_U_V_x_sigT,1);

% ANOVA
change_mat(:,1) = change_up_T_V_x_sigT;
change_mat(:,2) = change_up_U_V_x_sigT;
change_mat(:,3) = change_inv_T_V_x_sigT;
change_mat(:,4) = change_inv_U_V_x_sigT;
GROUP = {'Upright Trained','Upright Untrained','Inverted Trained','Inverted Untrained'}
[P,AOVATAB]=anova1(change_mat,GROUP)
title('One-Way ANOVA: Post-Pre Training Effects in Cluster')
set(gca,'FontSize',13)
% print('Post-Pre_ANOVA_TrainingEffects_UpInv_Cluster','-djpeg','-r300')

% TTESTS
[H,P,CI,STATS]=ttest(change_up_T_V_x_sigT,change_up_U_V_x_sigT);
[H,P,CI,STATS]=ttest(change_inv_T_V_x_sigT,change_inv_U_V_x_sigT);

[H,P,CI,STATS]=ttest(change_up_T_V_x_sigT,change_inv_T_V_x_sigT);


%% AVERAGE VOLT OVER CLUSTER WINDOW FOR EACH SUBJECT, & SEM V OVER TIMEPTS

% average across all timepoints in cluster (11 x 1 array of voltages:
% average voltage within cluster for each subject)
pre_up_T_sub_avgVinClust = mean(pre_up_T_V_x_sigT,2);
pre_up_U_sub_avgVinClust = mean(pre_up_U_V_x_sigT,2);
pre_inv_T_sub_avgVinClust = mean(pre_inv_T_V_x_sigT,2);
pre_inv_U_sub_avgVinClust = mean(pre_inv_U_V_x_sigT,2);
post_up_T_sub_avgVinClust = mean(post_up_T_V_x_sigT,2);
post_up_U_sub_avgVinClust = mean(post_up_U_V_x_sigT,2);
post_inv_T_sub_avgVinClust = mean(post_inv_T_V_x_sigT,2);
post_inv_U_sub_avgVinClust = mean(post_inv_U_V_x_sigT,2);

% standard error of voltages across all timepoints in cluster
pre_up_T_sub_SEMVinClust = std(pre_up_T_V_x_sigT,0,2)/sqrt(length(sigT));
pre_up_U_sub_SEMVinClust = std(pre_up_U_V_x_sigT,0,2)/sqrt(length(sigT));
pre_inv_T_sub_SEMVinClust = std(pre_inv_T_V_x_sigT,0,2)/sqrt(length(sigT));
pre_inv_U_sub_SEMVinClust = std(pre_inv_U_V_x_sigT,0,2)/sqrt(length(sigT));
post_up_T_sub_SEMVinClust = std(post_up_T_V_x_sigT,0,2)/sqrt(length(sigT));
post_up_U_sub_SEMVinClust = std(post_up_U_V_x_sigT,0,2)/sqrt(length(sigT));
post_inv_T_sub_SEMVinClust = std(post_inv_T_V_x_sigT,0,2)/sqrt(length(sigT));
post_inv_U_sub_SEMVinClust = std(post_inv_U_V_x_sigT,0,2)/sqrt(length(sigT));

figure(2)
scatter(pre_up_T_sub_avgVinClust*0+1,pre_up_T_sub_avgVinClust,'c')
hold on
scatter(pre_up_T_sub_avgVinClust*0+2,post_up_T_sub_avgVinClust,'filled','c')
scatter(pre_up_T_sub_avgVinClust*0+3,pre_up_U_sub_avgVinClust,'g')
scatter(pre_up_T_sub_avgVinClust*0+4,post_up_U_sub_avgVinClust,'filled','g')
scatter(pre_up_T_sub_avgVinClust*0+6,pre_inv_T_sub_avgVinClust,'c')
scatter(pre_up_T_sub_avgVinClust*0+7,post_inv_T_sub_avgVinClust,'filled','c')
scatter(pre_up_T_sub_avgVinClust*0+8,pre_inv_U_sub_avgVinClust,'g')
scatter(pre_up_T_sub_avgVinClust*0+9,post_inv_U_sub_avgVinClust,'filled','g')
axis([0 10 -1.4 1.4])

set(gca,'XTick',[2:5:10])
set(gca,'XTickLabel',{'Upright Cars','Inverted Cars'})
ylabel('Voltage (uV)')
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')
title({'Voltage in Cluster Across n=11 Subjects (12-76ms)';'Pre vs. Post Upright Cars in Trained Positions'})
set(gca,'FontSize',12)

figure(3)
subplot(2,1,1)
errorbar(pre_up_T_sub_avgVinClust,pre_up_T_sub_SEMVinClust,'co')
hold on
errorbar(post_up_T_sub_avgVinClust,post_up_T_sub_SEMVinClust,'bo')
errorbar(pre_up_U_sub_avgVinClust,pre_up_U_sub_SEMVinClust,'go')
errorbar(post_up_U_sub_avgVinClust,post_up_U_sub_SEMVinClust,'ko')
axis([0 12 -1.5 0.6])
set(gca,'XTick',[0:12])
set(gca,'XTickLabel',{[],subj{:},[]})
ylabel('uV')
title('Upright Cars')
set(gca,'FontSize',12)
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')

subplot(2,1,2)
errorbar(pre_inv_T_sub_avgVinClust,pre_inv_T_sub_SEMVinClust,'co')
hold on
errorbar(post_inv_T_sub_avgVinClust,post_inv_T_sub_SEMVinClust,'bo')
errorbar(pre_inv_U_sub_avgVinClust,pre_inv_U_sub_SEMVinClust,'go')
errorbar(post_inv_U_sub_avgVinClust,post_inv_U_sub_SEMVinClust,'ko')
axis([0 12 -1.5 0.6])
set(gca,'XTick',[0:12])
set(gca,'XTickLabel',{[],subj{:},[]})
ylabel('uV')
title('Inverted Cars')
set(gca,'FontSize',12)
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')






%% GROUP AVERAGE VOLT OVER CLUSTER WINDOW, & SEM ACROSS SUBJECTS

% group_avgVinClust = avg across sub_avgVinClust (1 double)
pre_up_T_group_avgVinClust = mean(pre_up_T_sub_avgVinClust);
pre_up_U_group_avgVinClust = mean(pre_up_U_sub_avgVinClust);
pre_inv_T_group_avgVinClust = mean(pre_inv_T_sub_avgVinClust);
pre_inv_U_group_avgVinClust = mean(pre_inv_U_sub_avgVinClust);
post_up_T_group_avgVinClust = mean(post_up_T_sub_avgVinClust);
post_up_U_group_avgVinClust = mean(post_up_U_sub_avgVinClust);
post_inv_T_group_avgVinClust = mean(post_inv_T_sub_avgVinClust);
post_inv_U_group_avgVinClust = mean(post_inv_U_sub_avgVinClust);

% group_SEMVinClust = SEM across sub_SEMV_inClust (1 double)
pre_up_T_group_SEMVinClust = std(pre_up_T_sub_avgVinClust)/sqrt(length(subj));
pre_up_U_group_SEMVinClust = std(pre_up_U_sub_avgVinClust)/sqrt(length(subj));
pre_inv_T_group_SEMVinClust = std(pre_inv_T_sub_avgVinClust)/sqrt(length(subj));
pre_inv_U_group_SEMVinClust = std(pre_inv_U_sub_avgVinClust)/sqrt(length(subj));
post_up_T_group_SEMVinClust = std(post_up_T_sub_avgVinClust)/sqrt(length(subj));
post_up_U_group_SEMVinClust = std(post_up_U_sub_avgVinClust)/sqrt(length(subj));
post_inv_T_group_SEMVinClust = std(post_inv_T_sub_avgVinClust)/sqrt(length(subj));
post_inv_U_group_SEMVinClust = std(post_inv_U_sub_avgVinClust)/sqrt(length(subj));

figure(2)
bar(1,pre_up_T_group_avgVinClust,'w','LineWidth',2,'EdgeColor','c')
hold on
bar(2,post_up_T_group_avgVinClust,'c')
bar(3,pre_up_U_group_avgVinClust,'w','LineWidth',2,'EdgeColor','g')
bar(4,post_up_U_group_avgVinClust,'g')
bar(5,pre_inv_T_group_avgVinClust,'w','LineWidth',2,'EdgeColor','c')
bar(6,post_inv_T_group_avgVinClust,'c')
bar(7,pre_inv_U_group_avgVinClust,'w','LineWidth',2,'EdgeColor','g')
bar(8,post_inv_U_group_avgVinClust,'g')
errorbar(1,pre_up_T_group_avgVinClust,pre_up_T_group_SEMVinClust,'k')
errorbar(2,post_up_T_group_avgVinClust,post_up_T_group_SEMVinClust,'k')
errorbar(3,pre_up_U_group_avgVinClust,pre_up_U_group_SEMVinClust,'k')
errorbar(4,post_up_U_group_avgVinClust,post_up_U_group_SEMVinClust,'k')
errorbar(5,pre_inv_T_group_avgVinClust,pre_inv_T_group_SEMVinClust,'k')
errorbar(6,post_inv_T_group_avgVinClust,post_inv_T_group_SEMVinClust,'k')
errorbar(7,pre_inv_U_group_avgVinClust,pre_inv_U_group_SEMVinClust,'k')
errorbar(8,post_inv_U_group_avgVinClust,post_inv_U_group_SEMVinClust,'k')

set(gca,'XTick',[2:4:8])
set(gca,'XTickLabel',{'Upright Cars','Inverted Cars'})
ylabel('Voltage (uV)')
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')
title({'Average Voltage in Cluster (12-76ms)';'Pre vs. Post Upright Cars in Trained Positions'})
set(gca,'FontSize',12)

%% Average across all significant electrodes at all timepoints

% 350 x 128 x 11
pre_up_T_allE =mean(mean(mean(pre_up_T_trialwiseavg(sigT,sigE,:),3),2),1);
pre_up_U_allE=mean(mean(mean(pre_up_U_trialwiseavg(sigT,sigE,:),3),2),1);
pre_inv_T_allE=mean(mean(mean(pre_inv_T_trialwiseavg(sigT,sigE,:),3),2),1);
pre_inv_U_allE=mean(mean(mean(pre_inv_U_trialwiseavg(sigT,sigE,:),3),2),1);
post_up_T_allE=mean(mean(mean(post_up_T_trialwiseavg(sigT,sigE,:),3),2),1);
post_up_U_allE=mean(mean(mean(post_up_U_trialwiseavg(sigT,sigE,:),3),2),1);
post_inv_T_allE=mean(mean(mean(post_inv_T_trialwiseavg(sigT,sigE,:),3),2),1);
post_inv_U_allE=mean(mean(mean(post_inv_U_trialwiseavg(sigT,sigE,:),3),2),1);

pre_up_T_SEMallE =std(mean(mean(pre_up_T_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
pre_up_U_SEMallE=std(mean(mean(pre_up_U_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
pre_inv_T_SEMallE=std(mean(mean(pre_inv_T_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
pre_inv_U_SEMallE=std(mean(mean(pre_inv_U_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
post_up_T_SEMallE=std(mean(mean(post_up_T_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
post_up_U_SEMallE=std(mean(mean(post_up_U_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
post_inv_T_SEMallE=std(mean(mean(post_inv_T_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));
post_inv_U_SEMallE=std(mean(mean(post_inv_U_trialwiseavg(sigT,sigE,:),2),1),0,3)/sqrt(length(subj));

figure(3)
bar(1,pre_up_T_allE,'w','LineWidth',2,'EdgeColor','c')
hold on
bar(2,post_up_T_allE,'c')
bar(3,pre_up_U_allE,'w','LineWidth',2,'EdgeColor','g')
bar(4,post_up_U_allE,'g')
bar(5,pre_inv_T_allE,'w','LineWidth',2,'EdgeColor','c')
bar(6,post_inv_T_allE,'c')
bar(7,pre_inv_U_allE,'w','LineWidth',2,'EdgeColor','g')
bar(8,post_inv_U_allE,'g')
errorbar(1,pre_up_T_allE,pre_up_T_SEMallE,'k')
errorbar(2,post_up_T_allE,post_up_T_SEMallE,'k')
errorbar(3,pre_up_U_allE,pre_up_U_SEMallE,'k')
errorbar(4,post_up_U_allE,post_up_U_SEMallE,'k')
errorbar(5,pre_inv_T_allE,pre_inv_T_SEMallE,'k')
errorbar(6,post_inv_T_allE,post_inv_T_SEMallE,'k')
errorbar(7,pre_inv_U_allE,pre_inv_U_SEMallE,'k')
errorbar(8,post_inv_U_allE,post_inv_U_SEMallE,'k')

