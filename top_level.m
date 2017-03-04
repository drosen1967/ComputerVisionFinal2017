% Top Level implementation of the SFM Program. Use this program to attach
% smaller modular programs that can attach to the large scale variables
% used. DO NOT bring in tons of images into this file. The imageSet will be
% enough to serve as a handle for this.

% Dan Rosen, Gunnar Hoglund 3/4/2017
%% Step 1
% Specify your image set name here, and declare your camera cal variables.

load('cameraParams.mat')
images = imageSet('./FinalImages');


%% Step 2
% Declare the all-important viewSet object here.
% Remember the view set lets us add important features with each image but
% more importantly it lets us extract connections between each image that
% we specify.

vs = viewSet;

[f,p] = extractFeatureSet(images,'SURF','sparse',cameraParams);
save('step2.mat','f','p');

%%
