clear all
close all 
clc

cam = webcam;

cam.Brightness = 100;
cam.Contrast = 100;

%preview(cam)

v = VideoWriter('myFile','Archival');
v.VideoCompressionMethod;

open(v);

for i = 1:100
    
img = snapshot(cam);

writeVideo(v,img)

I=getsnapshot(vid); 
%imshow(I); 
%F = im2frame(I); % Convert I to a movie frame 
%writeVideo(aviObject,F)
%pause(0.01);
end
close(v)
%Shuts down camera
clear('cam')