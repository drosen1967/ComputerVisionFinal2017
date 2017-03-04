function [ features_cell, points_cell ] = extractFeatureSet( image_set, method, quality, cameraParams )
% This function takes in several key COMP_Vis toolbox arguments from the
% top_level program and extracts features from the image Set and uses it to
% pupulate the viewSet. Note that in this implementation, I use it only to
% populate the set with key Points, Nothing else.

% Note that so far the only method available is SURF.
% I have made 2 qualities:
% dense = tons of features, don't care about how good.
% sparse= only a few features, more for find E matrix and things.

% The two returned objects are the view_Set and the collection of features
% that the points in the viewset were extracted from. These are especially
% useful in solving for the essential matrix.



if strcmp(method,'SURF')
    if strcmp(quality,'dense')
        metThresh = 500;
        numOct = 3;
        numScale = 6;
        for i = 1:image_set.Count
            I = rgb2gray(undistortImage(image_set.read(i),cameraParams));
            sP = detectSURFFeatures(I,'MetricThreshold',metThresh,'NumOctaves',numOct,'NumScaleLevels',numScale);
            [f,p] = extractFeatures(I,sP);
            features_cell{i} = f;
            points_cell{i} = p;
            percentDone = i/image_set.Count*100;
            fprintf('%3.2f percent complete, %5i points found\n',[percentDone,length(p)]);
        end
    else
        metThresh = 1000;
        numOct = 3;
        numScale = 3;
        for i = 1:image_set.Count
            I = rgb2gray(undistortImage(image_set.read(i),cameraParams));
            sP = detectSURFFeatures(I,'MetricThreshold',metThresh,'NumOctaves',numOct,'NumScaleLevels',numScale);
            [f,p] = extractFeatures(I,sP);
            features_cell{i} = f;
            points_cell{i} = p;
            percentDone = i/image_set.Count*100;
            fprintf('%3.2f percent complete, %5i points found\n',[percentDone,length(p)]);
        end
    end
else
    features_cell = 0;
    points_cell = 0;
end

end

