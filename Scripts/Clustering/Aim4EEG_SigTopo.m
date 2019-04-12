function Aim4EEG_SigTopo(clusterIdx,sigIdx,sigVals,WOI,EOI)

region_of_interest = lower(input('Electrodes of interest: left-posterior, right-posterior, all-posterior, or whole-brain? ','s'));

if strcmpi(region_of_interest,'left-posterior')
    ROI = [65, 66, 68, 69, 70, 73];
elseif strcmpi(region_of_interest,'right-posterior')
    ROI = [83, 84, 88, 89, 90, 94];
elseif strcmpi(region_of_interest,'all-posterior')
    ROI = [58, 59, 60, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 81, 82, 83, 84, 85, 88, 89, 90, 91, 94, 96];
elseif strcmpi(region_of_interest,'whole-brain')
    ROI = 1:128;
else
    disp('Invalid region of interest.')
end

clusterdefthresh = input('Cluster defining threshold (e.g., 0.05): ');
sigthresh = input('Significance threshold, p (e.g., 0.001): ');
load('elecPos.mat')

if ~isempty(sigIdx)
    
    S = sigIdx
    fprintf('p=%f.\n',sigVals(S))
    
else
    
    fprintf('No clusters survive significance threshold p<%f.\n',sigthresh)
    S = input('Which cluster should be explored? (e.g., 1): ');
    fprintf('Setting S to %d to explore cluster %d.\n',S,S)
    fprintf('p=%f at cluster defining threshold %f.\n',sigVals(S),clusterdefthresh)
    
end

for s = S
    
    figure(s)
    
    clust_temp_evol = (WOI(clusterIdx{s,1}(:,2))-101)*2;
    
    w1 = find(clust_temp_evol<=20);
    e1 = EOI(unique(clusterIdx{s,1}(w1,1)));
    
    w2 = find(clust_temp_evol>20 & clust_temp_evol<=40);
    e2 = EOI(unique(clusterIdx{s,1}(w2,1)));
    
    w3 = find(clust_temp_evol>40 & clust_temp_evol<=60);
    e3 = EOI(unique(clusterIdx{s,1}(w3,1)));
    
    w4 = find(clust_temp_evol>60 & clust_temp_evol<=80);
    e4 = EOI(unique(clusterIdx{s,1}(w4,1)));
    
    w5 = find(clust_temp_evol>80 & clust_temp_evol<=100);
    e5 = EOI(unique(clusterIdx{s,1}(w5,1)));
    
    w6 = find(clust_temp_evol>100 & clust_temp_evol<=120);
    e6 = EOI(unique(clusterIdx{s,1}(w6,1)));
    
    w7 = find(clust_temp_evol>120 & clust_temp_evol<=140);
    e7 = EOI(unique(clusterIdx{s,1}(w7,1)));
    
    w8 = find(clust_temp_evol>140 & clust_temp_evol<=150);
    e8 = EOI(unique(clusterIdx{s,1}(w8,1)));
    
    sigelecs = zeros(128,8);
    sigelecs(e1,1)=1;
    sigelecs(e2,2)=1;
    sigelecs(e3,3)=1;
    sigelecs(e4,4)=1;
    sigelecs(e5,5)=1;
    sigelecs(e6,6)=1;
    sigelecs(e7,7)=1;
    sigelecs(e8,8)=1;
    
    subplot(3,3,1)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e1,1),elecPos(e1,2),50,'filled','r')
    title({[num2str(length(e1)) ' electrodes'];'0-20ms'})
    axis off
    
    subplot(3,3,2)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e2,1),elecPos(e2,2),50,'filled','r')
    title({[num2str(length(e2)) ' electrodes'];'21-40ms'})
    axis off
    
    subplot(3,3,3)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e3,1),elecPos(e3,2),50,'filled','r')
    title({[num2str(length(e3)) ' electrodes'];'41-60ms'})
    axis off
    
    subplot(3,3,4)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e4,1),elecPos(e4,2),50,'filled','r')
    title({[num2str(length(e4)) ' electrodes'];'61-80ms'})
    axis off
    
    subplot(3,3,5)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e5,1),elecPos(e5,2),50,'filled','r')
    title({[num2str(length(e5)) ' electrodes'];'81-100ms'})
    axis off
    
    subplot(3,3,6)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e6,1),elecPos(e6,2),50,'filled','r')
    title({[num2str(length(e6)) ' electrodes'];'101-120ms'})
    axis off
    
    subplot(3,3,7)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e7,1),elecPos(e7,2),50,'filled','r')
    title({[num2str(length(e7)) ' electrodes'];'121-140ms'})
    axis off
    
    subplot(3,3,8)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(e8,1),elecPos(e8,2),50,'filled','r')
    title({[num2str(length(e8)) ' electrodes'];'141-150ms'})
    axis off
    
    subplot(3,3,9)
    scatter(elecPos(:,1),elecPos(:,2),50,'k')
    hold on
    scatter(elecPos(ROI,1),elecPos(ROI,2),50,'filled','k')
    title({[num2str(length(ROI)) ' electrodes'];'Region of Interest'})
    xlabel('cm')
    ylabel('cm')
    
end


end

