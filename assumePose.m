function [R,T] = assumePose(numImages,downAngle);
% Function creates evenly spaced cameras and plots them.
% Could be modified in the future to take in vector of angles to plot a camera at.

degree = 360/numImages;

Rm=@(x,y,z) [cosd(z)*cosd(y), cosd(z)*sind(y)*sind(x)-sind(z)*cosd(x), cosd(z)*sind(y)*cosd(x)+sind(z)*sind(x);...
             sind(z)*cosd(y), sind(z)*sind(y)*sind(x)+cosd(z)*cosd(x), sind(z)*sind(y)*cosd(x)-cosd(z)*sind(x);...
             -sind(y), cosd(y)*sind(x), cosd(y)*cosd(x)];

R = {};
T = {};

R{1} = eye(3);
T{1} = zeros(1,3);

for i = 2:numImages+1
    R{i} = Rm(0,-degree,0)*R{i-1};
    T{i} = T{i-1} + [-cosd((i-1)*degree),0,sind((i-1)*degree)]*Rm(0,+degree/2,0);
end

for i = 1:numImages
   R{i} = Rm(downAngle,0,0)*R{i}; 
end

hold on;
for i = 1:numImages
   plotCamera('Location',T{i},'Orientation',R{i},'Size',.1,'Label',num2str(i),'AxesVisible',true);
end
hold off;
xlim([-5,5]);
ylim([-1,1]);
zlim([-1,5]);

end
