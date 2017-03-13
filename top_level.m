% Top Level implementation of the SFM Program. Use this program to attach
% smaller modular programs that can attach to the large scale variables
% used. DO NOT bring in tons of images into this file. The imageSet will be
% enough to serve as a handle for this.

% Dan Rosen, Gunnar Hoglund 3/4/2017
%% Step 1
% Specify your image set name here, and declare your camera cal variables.

load('cameraParams.mat')
images = imageSet('./FinalImages5');


%% Step 2
% Declare the all-important viewSet object here.
% Remember the view set lets us add important features with each image but
% more importantly it lets us extract connections between each image that
% we specify.



[f,p] = extractFeatureSet(images,'SURF','sparse',cameraParams);
save('step2.mat','f','p');

%% Step 3
% Extract matches from all image pairs: 1 to 2, 2 to 3,..., end to 1
% Save these matches to a cell arrray.
m = extractMatches(f,'sparse');
save('step3.mat','m');

%% Step 4
[R,T] = assumePose(images.Count,0);

vs = viewSet;

vs = addView(vs,1,'Orientation',R{1},'Location',T{1},'Points',p{1});

for i = 2:images.Count 
    vs = addView(vs,i,'Orientation',R{i},'Location',T{i},'Points',p{i});
    vs = addConnection(vs,i-1,i,'Matches',m{i-1});
end
vs = addConnection(vs,images.Count,1,'Matches',m{images.Count});

tracks = findTracks(vs);
camPoses = poses(vs);

xyz = triangulateMultiview(tracks,camPoses,cameraParams);

[xyz,refindedPoses] = bundleAdjustment(xyz,tracks,camPoses,cameraParams,'Verbose',true,'RelativeTolerance',1e-20,'MaxIterations',1e3,'PointsUndistorted',true,'FixedViewIDs',1);


% %% Step 4 alternate
% % In this I have a basic user interface that asks if the calculated pose is
% % good.
% vs = viewSet;
% 
% vs = addView(vs,1,'Orientation',eye(3),'Location',zeros(1,3),'Points',p{1});
% H = eye(4);
% unMoving = 1;
% 
% for i = 2:length(m)-1
%    
%     match1 = p{i-1}(m{i-1}(:,1));
%     match2 = p{i}(m{i-1}(:,2));
%     disp(i);
%     n = 0;
%     while n==0
%         if vs.hasView(i)
%             vs = deleteView(vs,i); 
%             disp('hole');
%         end
%         try
%             [R,T,in] = helperEstimateRelativePose(match1,match2,cameraParams);
%         catch
%             R = eye(3);
%             T = [1,0,0];
%             disp('Given up');
%         end
%         r = R';
%         t = -T*R';
%         M=[r,t';0,0,0,1];
%         U = H*M;
%         R = U(1:3,1:3)';
%         T = -U(1:3,4)'/R;
%         vs = addView(vs,i,'Orientation',R,'Location',T,'Points',p{i});
%         vs = addConnection(vs,i-1,i,'Matches',m{i-1}(in,:));
%         tracks = findTracks(vs);
%         camPoses = poses(vs);
%         figure(1);
%         hold on;
%         for i = 1:size(camPoses,1)
%             plotCamera('Orientation',camPoses.Orientation{i},'Location',camPoses.Location{i},'Size',.1);
%         end
%         axis('equal');
%         hold off;
%         n=input('1 is good');
%     end
%     H = [camPoses.Orientation{i}',(-camPoses.Location{i}*camPoses.Orientation{i}')';0,0,0,1];
% end
% 
% 
% %% Step 4
% % Determine the pose of each camera.
% 
% vs = viewSet;
% 
% vs = addView(vs,1,'Orientation',eye(3),'Location',zeros(1,3),'Points',p{1});
% H = eye(4);
% unMoving = 1;
% 
% for i = 2:length(m)-1
%     match1 = p{i-1}(m{i-1}(:,1));
%     match2 = p{i}(m{i-1}(:,2));
%     disp(i);
%     try
%        [R,T,in] = helperEstimateRelativePose(match1,match2,cameraParams);
%     catch
%         R = eye(3);
%         T = [1,0,0];
%         in = [];
%         disp('Given up');
%     end
%     r = R';
%     t = -T*R';
%     M=[r,t';0,0,0,1];
%     H = H*M;
%     R = H(1:3,1:3)';
%     T = -H(1:3,4)'/R;
%     vs = addView(vs,i,'Orientation',R,'Location',T,'Points',p{i});
%     vs = addConnection(vs,i-1,i,'Matches',m{i-1}(in,:));
%     tracks = findTracks(vs);
%     camPoses = poses(vs);
%     xyz = triangulateMultiview(tracks,camPoses,cameraParams);
%     [xyz,camPoses] = bundleAdjustment(xyz,tracks,camPoses,cameraParams,'MaxIterations',1000,'RelativeTolerance',1e-30,'FixedViewID',1,'Verbose',true,'PointsUndistorted',true);
%     H = [camPoses.Orientation{i}',(-camPoses.Location{i}*camPoses.Orientation{i}')';0,0,0,1];
%     vs = updateView(vs,i,'Orientation',camPoses.Orientation{i},'Location',camPoses.Location{i});
% end
% %%


figure(1);
hold on;
for i = 1:size(camPoses,1)
    plotCamera('Orientation',camPoses.Orientation{i},'Location',camPoses.Location{i},'Size',.1);
end
axis('equal');


pc = pointCloud(xyz);
% pc = pcdenoise(pc,'NumNeighbors',10000,'Threshold',1e-10);


pcshow(pc,'MarkerSize',60);
ylim([-3,3]);
xlim([-4,4]);
zlim([0,10]);
hold off;
pcwrite(pc,'pc.ply');
