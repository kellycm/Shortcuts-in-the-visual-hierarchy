function [expt,perm,accu_sig,sigVals,sigIdx,clusterIdx,EOI,WOI]=Aim4EEGClusteringPipelineWrapper(clusterdefthresh,alpha)

% contrast of interest
comparison = 'prepostleft';

% load group-averaged EEG data
cd('/Users/kellymartin/Desktop/Maxlab_CRCNS/PrePostLeft')
fprintf('Loading experimental & bootstrapped data for contrast %s.\n',comparison);
condition_filename = [comparison '_groupmean.mat'];
load(condition_filename);

% move back to where everything else lives
cd('/Users/kellymartin/Desktop/Maxlab_CRCNS/Fixed!')

% run analysis with electrodes of interest?
region_of_interest = lower(input('Electrodes of interest: left-posterior, right-posterior, all-posterior, whole-brain, or manual? ','s'));

% within what cm radius should electrode neighborhoods be formed?
elecRadiuscm = input('Electrode neighborhood radius (cm) (3 or 4 is typical)? ');

% run time window of interest?
window_of_interest = lower(input('Time window of interest: early, middle, late, all, manual? ','s'));

% 128 x 3 xyz coordinates of electrodes
load('elecPos.mat');

% electrodes of interest
if strcmpi(region_of_interest,'left-posterior')
    EOI = [65, 66, 68, 69, 70, 73];
elseif strcmpi(region_of_interest,'right-posterior')
    EOI = [83, 84, 88, 89, 90, 94];
elseif strcmpi(region_of_interest,'all-posterior')
    EOI = [58, 59, 60, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 81, 82, 83, 84, 85, 88, 89, 90, 91, 94, 96];
elseif strcmpi(region_of_interest,'whole-brain')
    EOI = 1:128;
elseif stcmpi(region_of_interest,'manual')
    EOI = input('Vector of electrodes: ');
else
    disp('Invalid region of interest.')
end

% electrodes of interest
if strcmpi(window_of_interest,'early')
    WOI = (101:176); %0-150ms post stimulus onset
elseif strcmpi(window_of_interest,'middle')
    WOI = (151:226); %100-250ms post stimulus onset
elseif strcmpi(window_of_interest,'late')
    WOI = (201:276); %200ms-350ms post stimulus onset
elseif strcmpi(window_of_interest,'all')
    WOI = (101:350); %stimulus onset to the end
elseif strcmpi(window_of_interest,'manual')
    start_window = input('Start time (ms PSO): ');
    end_window = input('End time (ms PSO): ');
    start_window_converted = (start_window/2)+101;
    end_window_converted = (end_window/2)+101;
    WOI = start_window_converted:end_window_converted;   
else
    disp('Invalid time window of interest.')
end

% electrode neighborhoods
fprintf('Retrieving xyz coordinates for %.0f %s electrodes.\n',length(EOI),region_of_interest);
elecLocs = elecPos(EOI,:); % nEOI x 3 matrix of electrode xyz coordinates
fprintf('Retrieving electrode neighborhoods in radius of 4.\n');
[elecGroups] = spotlightCreater(elecLocs,elecRadiuscm,'ROI') % 3 or 4 is typical
if length(elecGroups)~=length(EOI)
    disp('Mismatch in number of electrodes and distance calculation.')
end

% experimental and bootstrapped ttests for EOI in WOI
fprintf('Retrieving group-averaged EEG data for %.0f %s electrodes.\n',length(EOI),region_of_interest);
% named to match sigSearchlightPlot convention
expt = all_expt_results(EOI,WOI);
perm = all_perm_results(EOI,WOI,:);

if clusterdefthresh < (1/size(perm,3))
    disp('Warning: cluster defining threshold exceeds number of permutations.');
    disp('Change to normal distribution in spatialClusGenerator.m: ');
    disp('Uncomment lines 13 & 14, and comment out line 16.');
end

% Run sigSearchlightPlot.m
[accu_sig,sigVals,sigIdx,clusterIdx] = sigSearchlightPlot(expt,perm,elecGroups,clusterdefthresh,alpha);
% clusterIdx cell array contains all the clusters identified
% sigIdx tells you indices of clusters with mass significant relative to
% the laragest cluster in permdata.

if ~isempty(clusterIdx)
    if sigIdx > 0
        for c = 1:length(sigIdx)
            sigElecsidx = unique(clusterIdx{sigIdx(c)}(:,1));
            sigElecs{c} = EOI(sigElecsidx);
            sigWindows{c} = clusterIdx{sigIdx(c)}(:,2);
        end
    else
        fprintf('There were no significant clusters at the %f threshold.\n',clusterdefthresh);
    end
else
    fprintf('There were no significant clusters at the %f threshold in %s window.\n',clusterdefthresh,window_of_interest);
end
