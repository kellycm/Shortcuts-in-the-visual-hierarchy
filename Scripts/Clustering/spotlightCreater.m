function [elecGroups] = spotlightCreater(elecLocs,thresh,flag)

% elecLocs are a n-by-3 matrix of x-,y-,z-coordinates for the electrodes
% thresh can either be a count or a radius depending on whether 'KNN' or 'ROI' is used respectively

elecDists = dist(elecLocs');
% clc
switch flag
    case 'KNN'  % create neighborhood structure so that all neighborhoods have the same # of electrodes
        %% To  create searchlight using K-NN method
        for e = 1:size(elecLocs,1)
           foo = elecDists(e,:);
           [~,sortIdx] = sort(foo);
           elecGroups{e} = sortIdx(1:thresh+1);
        end
    case 'ROI'  % create neighborhood structure so that all neighborhoods capture electordes within a given radius
    %% To create spherical ROIs
        filterElecDists = elecDists<thresh;
        for e = 1:size(elecLocs,1)
           foo = setdiff(find(filterElecDists(e,:)),e);
           filterElecLocs = elecLocs(foo,:);
           elecCurrent = elecLocs(e,:);
           elecGroups{e} = foo; 
        end
end
