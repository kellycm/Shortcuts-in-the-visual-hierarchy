function Aim4EEG_PostMinusPre_WithinSubjSEM(sigElecs,sigTimes,subj,withincond1_subjavgmat,withincond2_subjavgmat,withincond3_subjavgmat,withincond4_subjavgmat,withincond5_subjavgmat,withincond6_subjavgmat,withincond7_subjavgmat,withincond8_subjavgmat)

% subtract post-pre averages and within-subject SEMs
cond21_postminuspre_avg = mean(withincond2_subjavgmat,2)-mean(withincond1_subjavgmat,2);
cond21_postminuspre_SEM = cond2_withinsubjSEM-cond1_withinsubjSEM;

cond43_postminuspre_avg = mean(withincond4_subjavgmat,2)-mean(withincond3_subjavgmat,2);
cond43_postminuspre_SEM = cond4_withinsubjSEM-cond3_withinsubjSEM;

cond65_postminuspre_avg = mean(withincond6_subjavgmat,2)-mean(withincond5_subjavgmat,2);
cond65_postminuspre_SEM = cond6_withinsubjSEM-cond5_withinsubjSEM;

cond87_postminuspre_avg = mean(withincond8_subjavgmat,2)-mean(withincond7_subjavgmat,2);
cond87_postminuspre_SEM = cond8_withinsubjSEM-cond7_withinsubjSEM;

%% POST-PRE FOR UPRIGHT AND INVERTED, TRAINED VS. UNTRAINED
figure;
subplot(1,2,1)
errorbar(cond21_postminuspre_avg,cond21_postminuspre_SEM,'c')
hold on
errorbar(cond43_postminuspre_avg,cond43_postminuspre_SEM,'g')

timeTicks=[22:6:70];
set(gca,'XTick',0:3:24,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
set(gca,'YLim',[-1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Upright Cars'; [num2str(length(sigElecs)) ' All Posterior Channels from All L-Presented Trials Pre vs. Post Cluster']})
legend('Upright Trained','Upright Untrained')

subplot(1,2,2)
errorbar(cond65_postminuspre_avg,cond65_postminuspre_SEM,'c')
hold on
errorbar(cond87_postminuspre_avg,cond87_postminuspre_SEM,'g')

timeTicks=[22:6:70];
set(gca,'XTick',0:3:24,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
set(gca,'YLim',[-1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Inverted Cars'; [num2str(length(sigElecs)) ' All Posterior Channels from All L-Presented Trials Pre vs. Post Cluster']})
legend('Inverted Trained','Inverted Untrained')

% POST-PRE FOR TRAINED AND UNTRAINED, UPRIGHT VS. INVERTED
figure;
subplot(1,2,1)
errorbar(cond21_postminuspre_avg,cond21_postminuspre_SEM,'k')
hold on
errorbar(cond65_postminuspre_avg,cond65_postminuspre_SEM,'m')

timeTicks=[22:6:70];
set(gca,'XTick',0:3:24,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
set(gca,'YLim',[-1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Trained'; [num2str(length(sigElecs)) ' All Posterior Channels from All L-Presented Trials Pre vs. Post Cluster']})
legend('Upright Trained','Inverted Trained')

subplot(1,2,2)
errorbar(cond43_postminuspre_avg,cond43_postminuspre_SEM,'k')
hold on
errorbar(cond87_postminuspre_avg,cond87_postminuspre_SEM,'m')

timeTicks=[22:6:70];
set(gca,'XTick',0:3:24,'XTickLabels',timeTicks)
set(gca,'FontSize',13)
set(gca,'YLim',[-1 0.6])
xlabel('Time (ms)')
ylabel('uV')
title({'Post-Pre Untrained'; [num2str(length(sigElecs)) ' All Posterior Channels from All L-Presented Trials Pre vs. Post Cluster']})
legend('Upright Untrained','Inverted Untrained')

%% Bar Plots of Average Voltage in Cluster for Each Condition

cond21_postminuspre_avgtotal = mean(cond21_postminuspre_avg);
cond21_postminuspre_SEMtotal = std(mean(withincond2_subjavgmat,1)-mean(withincond1_subjavgmat,1))/sqrt(length(subj));

cond43_postminuspre_avgtotal = mean(cond43_postminuspre_avg);
cond43_postminuspre_SEMtotal = std(mean(withincond4_subjavgmat,1)-mean(withincond3_subjavgmat,1))/sqrt(length(subj));

cond65_postminuspre_avgtotal = mean(cond65_postminuspre_avg);
cond65_postminuspre_SEMtotal = std(mean(withincond6_subjavgmat,1)-mean(withincond5_subjavgmat,1))/sqrt(length(subj));

cond87_postminuspre_avgtotal = mean(cond87_postminuspre_avg);
cond87_postminuspre_SEMtotal = std(mean(withincond8_subjavgmat,1)-mean(withincond7_subjavgmat,1))/sqrt(length(subj));

figure;
bar(1,cond21_postminuspre_avgtotal,'FaceColor','c')
hold on
errorbar(1,cond21_postminuspre_avgtotal,cond21_postminuspre_SEMtotal,'k')
bar(2,cond43_postminuspre_avgtotal,'FaceColor','g')
errorbar(2,cond43_postminuspre_avgtotal,cond43_postminuspre_SEMtotal,'k')
bar(3,cond65_postminuspre_avgtotal,'FaceColor','c')
errorbar(3,cond65_postminuspre_avgtotal,cond65_postminuspre_SEMtotal,'k')
bar(4,cond87_postminuspre_avgtotal,'FaceColor','g')
errorbar(4,cond87_postminuspre_avgtotal,cond87_postminuspre_SEMtotal,'k')

set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'Up Trained','Up Untrained','Inv Trained','Inv Untrained'})
set(gca,'FontSize',13)
title({['Average Post-Pre Voltage Timecourse'];['in Post vs. Pre All L-Presented Trials All-Posterior Cluster']})

%% Subplots of each condition for individual subjects

cond21_postminuspre_timepointSEM = std(withincond2_subjavgmat-withincond1_subjavgmat,1)/sqrt(length(sigTimes));
cond43_postminuspre_timepointSEM = std(withincond4_subjavgmat-withincond3_subjavgmat,1)/sqrt(length(sigTimes));
cond65_postminuspre_timepointSEM = std(withincond6_subjavgmat-withincond5_subjavgmat,1)/sqrt(length(sigTimes));
cond87_postminuspre_timepointSEM = std(withincond8_subjavgmat-withincond7_subjavgmat,1)/sqrt(length(sigTimes));

figure;
subplot(2,2,1)
bar(mean(withincond2_subjavgmat,1)-mean(withincond1_subjavgmat,1),'c')
hold on
errorbar(mean(withincond2_subjavgmat,1)-mean(withincond1_subjavgmat,1),cond21_postminuspre_timepointSEM,'k','LineStyle','none')
title('Post-Pre Upright Cars Trained')
xlabel('Subjects')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-2.3,2])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',subj(:))

subplot(2,2,2)
bar(mean(withincond4_subjavgmat,1)-mean(withincond3_subjavgmat,1),'g')
hold on
errorbar(mean(withincond4_subjavgmat,1)-mean(withincond3_subjavgmat,1),cond43_postminuspre_timepointSEM,'k','LineStyle','none')
title('Post-Pre Upright Cars Untrained')
xlabel('Subjects')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-2.3,2])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',subj(:))

subplot(2,2,3)
bar(mean(withincond6_subjavgmat,1)-mean(withincond5_subjavgmat,1),'c')
hold on
errorbar(mean(withincond6_subjavgmat,1)-mean(withincond5_subjavgmat,1),cond65_postminuspre_timepointSEM,'k','LineStyle','none')
title('Post-Pre Inverted Cars Trained')
xlabel('Subjects')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-2.3,2])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',subj(:))

subplot(2,2,4)
bar(mean(withincond8_subjavgmat,1)-mean(withincond7_subjavgmat,1),'g')
hold on
errorbar(mean(withincond8_subjavgmat,1)-mean(withincond7_subjavgmat,1),cond87_postminuspre_timepointSEM,'k','LineStyle','none')
title('Post-Pre Inverted Cars Untrained')
xlabel('Subjects')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-2.3,2])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',subj(:))

%% INDIVIDUAL CONDITIONS BAR PLOTS

figure;
subplot(1,2,1)
bar(1,mean(mean(withincond1_subjavgmat,1),2),'c')
hold on
bar(2,mean(mean(withincond2_subjavgmat,1),2),'FaceColor','w','EdgeColor','c','LineWidth',2)
bar(3,mean(mean(withincond3_subjavgmat,1),2),'g')
bar(4,mean(mean(withincond4_subjavgmat,1),2),'FaceColor','w','EdgeColor','g','LineWidth',2)
errorbar(1,mean(mean(withincond1_subjavgmat,1),2),std(mean(withincond1_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(2,mean(mean(withincond2_subjavgmat,1),2),std(mean(withincond2_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(3,mean(mean(withincond3_subjavgmat,1),2),std(mean(withincond3_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(4,mean(mean(withincond4_subjavgmat,1),2),std(mean(withincond4_subjavgmat,1))/sqrt(length(subj)),'k');

title('Upright Cars')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-1,1])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',[])
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')

subplot(1,2,2)
bar(1,mean(mean(withincond5_subjavgmat,1),2),'c')
hold on
bar(2,mean(mean(withincond6_subjavgmat,1),2),'FaceColor','w','EdgeColor','c','LineWidth',2)
bar(3,mean(mean(withincond7_subjavgmat,1),2),'g')
bar(4,mean(mean(withincond8_subjavgmat,1),2),'FaceColor','w','EdgeColor','g','LineWidth',2)
errorbar(1,mean(mean(withincond5_subjavgmat,1),2),std(mean(withincond5_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(2,mean(mean(withincond6_subjavgmat,1),2),std(mean(withincond6_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(3,mean(mean(withincond7_subjavgmat,1),2),std(mean(withincond7_subjavgmat,1))/sqrt(length(subj)),'k');
errorbar(4,mean(mean(withincond8_subjavgmat,1),2),std(mean(withincond8_subjavgmat,1))/sqrt(length(subj)),'k');

title('Inverted Cars')
ylabel('Average Voltage (uV)')
set(gca,'YLim',[-1,1])
set(gca,'FontSize',13)
set(gca,'XTick',1:11)
set(gca,'XTickLabel',[])
legend('Pre Trained','Post Trained','Pre Untrained','Post Untrained')

