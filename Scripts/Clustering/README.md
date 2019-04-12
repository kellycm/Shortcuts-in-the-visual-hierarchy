# Clustering Scripts

Cluster mass correction analysis

Aim4EEGMakePermutedData.m needs to be run to generate the permuted data

Aim4EEGClusterphobic.m needs to then be run to calculate the t-statistic for the comparison of interest across all trials at each timepoint at each electrode for each subject,

Aim4EEGClusteringGroupMean.m should then be run to average across the group.

Clustering Pipeline Wrapper calls elecPos.mat (128x3 xyz coordinates of electrodes), spotlightCreater (generates electrode neighborhoods), sigSearchlightPlot (produces clusterIdx cell array with all clusters identified, sigIdx with indices of clusters with significant mass relative to the largest cluster in the permuted data). These are adapted from Sri's scripts, and they call within them two of Sri's other scripts: findCluster.m and spatialClusGenerator.m. It works on the group data for the comparison of interest from Aim4EEGClusteringGroupMean.m.

Plotting functions:

Aim4EEGClusteringPlots.m can be run to make plots of the average voltage for the condition. It calls Aim4EEGSingleElecERPs.m.

Aim4EEG_SigTopo.m plots the significant electrodes for a cluster within snapshots of the 0-150ms post stimulus time window.

Aim4EEGClusteringBarPlots2.m plots the average voltage in the timepoints of the cluster.. It may be pretty out of date and not written well or useful. I think I made it quickly for something.

Aim4EEG_PostMinusPre_WithinSubjSEM.m does the more sophisticated calculation of standard error that removes more indvidual subject variability than the traditional calculation.

