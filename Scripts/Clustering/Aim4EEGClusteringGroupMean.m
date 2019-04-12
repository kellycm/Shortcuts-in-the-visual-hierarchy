function [all_expt_results,all_perm_results]=Aim4EEGClusteringGroupMean

comparison = 'prepostleft';

subj = {'p23','p26','p27','p28','p30','p31','p32','p34','p35','p38','p41'};

cd('/Users/kellymartin/Desktop/Maxlab_CRCNS/PrePostLeft')

for s = 1:length(subj)
    
    filename = [subj{s} '_' comparison '_expt_and_bootstrapped_data.mat'];
    
    fprintf('Loading %s...\n',filename);
    load(filename)
    
    fprintf('Pulling experimental & bootstrapped results for subject %s...\n',subj{s});
    all_perm_results(:,:,:,s) = permResults;
    all_expt_results(:,:,s) = exptResults;
    
    disp('Done.')
    
    clear permResults exptResults
    
end

fprintf('Number of subjects is %.0f.\n',length(subj));
fprintf('Subjects dimension of all_perm_results is %.0f.\n',size(all_perm_results,4));
fprintf('Subjects dimension of all_expt_results is %.0f.\n',size(all_expt_results,3));
fprintf('Averaging across subjects.\n');
all_perm_results = mean(all_perm_results,4);
all_expt_results = mean(all_expt_results,3);

fprintf('Done. Saving %s_groupmean.mat.\n', comparison);
save([comparison '_groupmean.mat'],'all_expt_results','all_perm_results','-v7.3');