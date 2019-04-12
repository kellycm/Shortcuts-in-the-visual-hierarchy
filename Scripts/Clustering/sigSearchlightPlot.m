function [accu_sig,sigVals,sigIdx,clusterIdx] = sigSearchlightPlot(accu,accuperm,elecs,thresh,sigVal)

%load('exptData.mat') %accu
%load('permData.mat') %accuperm
%load('elecGroups.mat') %elecs
%thresh=0.01 %cluster defining threshold
%sigVal=0.05 %significance against which the clusters are compared

% accu_sig = sigSearchlightPlot(exptData.prepostupT,permData.prepostupT,elecGroups,0.01,0.05,~)

elecDists_idx = zeros(length(elecs));
for i = 1:length(elecs)
    elecDists_idx(i,elecs{i}) = 1;
end
elecDensity = cellfun(@length,elecs);
accu(accu==0) = NaN;
accuperm(accuperm==0) = NaN;

[accu_clus,clusterIdx] = spatialClusGenerator(accu,accuperm,thresh,elecDists_idx);

if ~isempty(accu_clus) % KM edited 8/29/18
    
    for j = 1:size(accuperm,3) % iterate through each permutation
        dat = squeeze(accuperm(:,:,j));
        foo = spatialClusGenerator(dat,accuperm,thresh,elecDists_idx);
        clusMassPerm(j)=max(foo);
    end
    
    
    for i = 1:length(accu_clus)
        sigVals(i) = sum(max(accu_clus(i))<=clusMassPerm)/length(clusMassPerm);
    end
    
    sigIdx = find(sigVals<=sigVal);
    
    % sigIdx =3;
    accu_sig = zeros(size(accu));
    
    for i = 1:length(sigIdx)
        idx = sigIdx(i);
        for j = 1:length(clusterIdx{idx}(:,2))
            elecsUsed = clusterIdx{idx}(j,1);
            accu_sig(elecsUsed,clusterIdx{idx}(j,2)) = accu(clusterIdx{idx}(j,1),clusterIdx{idx}(j,2));
        end
    end
    
    % for i = 1:length(sigIdx)
    %     idx = sigIdx(i);
    %     for j = 1:length(clusterIdx{idx}(:,2))
    %         elecsUsed = elecs{clusterIdx{idx}(j,1)};
    %         accu_sig(elecsUsed,clusterIdx{idx}(j,2)) = accu(clusterIdx{idx}(j,1),clusterIdx{idx}(j,2));
    %     end
    % end
    clusterIdx = clusterIdx';
    
    
    clear tBins clear tBins2
    count = 1;
    window = 6;
    lag = 2;
    for t = 101:lag:251-window
        tBins(count,:) = [t t+window];
        count = count+1;
    end
    tBins2 = tBins-101;
    tBins2 = tBins2*2;
    clear count window t lag
    
    
else
    accu_sig=[];
    sigVals=[];
    sigIdx=[];
    clusterIdx=[];
end
% plotAccuMap(accu_sig,elecDensity,6,subj)
