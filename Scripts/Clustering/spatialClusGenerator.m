function [clusMass, clusterIdx] = spatialClusGenerator(data,perm,alpha,elecDists_idx)

clusMass = 0;

for i = 1:size(data,1) % iterate through first dimension should be channels
    for j = 1:size(data,2) % iterate through second dimension should be time
        if size(data,2)>1 % there is a time component
            foo = squeeze(perm(i,j,:));
        else % there is no time component
            foo = perm(i,:);
        end
        if ~isnan(data(i,j))
%            zval = (mean(foo)-data(i,j))/std(foo);
%            p_val(i,j) = normcdf(zval);
            
             p_val(i,j) = sum(foo>=data(i,j))/length(foo);
        else
            p_val(i,j) =1;
        end
    end
end

onoff = p_val<=alpha;


if sum(sum(onoff)) % KM edited 8/29/18
    
    onoff = permute(onoff,[1,3,2]); % format: onoff(Chan,Freq,Time)
    % if size(data,1)<128
    %     elecDists_idx = ones(size(data,1));
    % %     elecDists_idx = diag(ones(1,size(data,1)),1);
    % end
    
    [clusPos,num] = findCluster(onoff,elecDists_idx);
    
    
    clusPos = squeeze(clusPos);
    for j = 1:num
        idx = find(clusPos==j);
        clusMass(j) =  sum(data(idx));
        %     clusMass(j) =  length(idx);
        [I,J] = ind2sub(size(clusPos),idx);
        clusterIdx{j} = [I,J];
    end
    
    % accu_sig = zeros(size(data));
    %
    % for i = 1:length(I)
    %    accu_sig(I(i),J(i)) = data(I(i),J(i));
    % end
    
elseif sum(sum(onoff))==0
    fprintf('No clusters survive at %f threshold.\n',alpha);
    clusMass=0;
    clusterIdx=[];
end