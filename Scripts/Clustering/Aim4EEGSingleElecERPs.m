function Aim4EEGSingleElecERPs(subj,sigElecs,condition1_groupavg,condition2_groupavg,condition3_groupavg,condition4_groupavg)
% Called by Aim4EEGClusteringPlots.m
% Plots avg voltage timecourse with SEM error bars at each electrode.

for c = 1:length(sigElecs) 
    
    condition1_EOI = mean(condition1_groupavg(:,sigElecs(c)),2); % timepoints x EOI    
    condition1_SEM = std(mean(condition1_trialwiseavg(:,sigElecs(c),:),2),0,3)/sqrt(length(subj));
    
    condition2_EOI = mean(condition2_groupavg(:,sigElecs(c)),2); % timepoints x EOI    
    condition2_SEM = std(mean(condition2_trialwiseavg(:,sigElecs(c),:),2),0,3)/sqrt(length(subj));
       
    condition3_EOI = mean(condition3_groupavg(:,sigElecs(c)),2); % timepoints x EOI    
    condition3_SEM = std(mean(condition3_trialwiseavg(:,sigElecs(c),:),2),0,3)/sqrt(length(subj));
    
    condition4_EOI = mean(condition4_groupavg(:,sigElecs(c)),2); % timepoints x EOI    
    condition4_SEM = std(mean(condition4_trialwiseavg(:,sigElecs(c),:),2),0,3)/sqrt(length(subj));
    
    
    % subplots of voltage at each timepoint
    figure;
    subplot(6,4,c)
    errorbar(condition1_EOI,condition1_SEM,'c:')
    hold on
    errorbar(condition2_EOI,condition2_SEM,'c')
    errorbar(condition3_EOI,condition3_SEM,'g:')
    errorbar(condition4_EOI,condition4_SEM,'g')
    
    timeTicks=[-0.2:0.1:0.5];
    set(gca,'XTick',0:50:350,'XTickLabels',timeTicks)
    %set(gca,'FontSize',13)
    axis([100 150 -1.5 0.5])
    xlabel('Time (s)')
    ylabel('uV')
    %legend('Pre Up Trained','Post Up Trained')
    %title([{'Upright Cars Pre vs. Post Trained: ', num2str(length(sigElecs(c))) ' Elecs'}])
    hold off
    
    % disp('Printing high res plot image.')
    %print([comparison '_' num2str(window_start) 'ms_to' num2str(window_end) 'ms'],'-djpeg','-r300')

    
end