function [ m ] = extractMatches( features,  quality )
%This function extracts the matching features from each image and returns
%them in a cell format. This is to be used later with the estimateEssential
%Matrix function. Recall also that this will return the same number of
%matches as there are photos. The first image is between image 1 and 2, and
%the second is between 2 and 3 and so on. But the last match is between the
%last image and the FIRST image! This is to allow us to complete a loop of
%an object or building.

%Currently I have made two levels for this function, one that returns a
%conservative subset called sparse, and one that returns a fairly free
%subset, dense

if strcmp(quality,'sparse')
    matThresh = 10;
    maxR = .5;
    for i = 1:size(features,2)-1
        m{i} = matchFeatures(features{i},features{i+1}, 'MatchThreshold',matThresh,'MaxRatio',maxR);
        fprintf('%3.2f percent complete, %10i matches found\n',[i/size(features,2)*100,length(m{i})]);
    end
    m{size(features,2)} = matchFeatures(features{size(features,2)},features{1}, 'MatchThreshold',matThresh,'MaxRatio',maxR);
else
    matThresh = 10;
    maxR = .8;
    for i = 1:size(features,2)-1
        m{i} = matchFeatures(features{i},features{i+1}, 'MatchThreshold',matThresh,'MaxRatio',maxR);
        fprintf('%3.2f percent complete, %10i matches found\n',[i/size(features,2)*100,length(m{i})]);
    end
    m{size(features,2)} = matchFeatures(features{size(features,2)},features{1}, 'MatchThreshold',matThresh,'MaxRatio',maxR);
end

end

