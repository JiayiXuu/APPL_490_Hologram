clear all
close all 
clc

cam = webcam;
cam.Brightness = 100;
cam.Contrast = 100;

Nsteps = 100;
NRecordings = 5;
%preview(cam)

basedata = linspace(0,0,Nsteps);


for i = 1:Nsteps
disp(i)
img = snapshot(cam);
 img = double(img);
 img = mean(mean(mean(img)));
 basedata(i) = img;
 scatter(i,img); 
 hold on;
 pause(0.01);
end

baseline = mean(basedata(30:end));
stdbasedata = std(basedata(30:end));

Saveme.baselinedata = basedata;
Saveme.baselinemean = baseline;
Saveme.stdbasedata = stdbasedata;

pause;
input('Hit enter to continue with first recording')

for j = 1:NRecordings

offsetdata =  linspace(0,0,Nsteps);
rawdata = linspace(0,0, Nsteps);

for i = 1:Nsteps
disp(i)
    img = snapshot(cam);
 img = double(img);
 img = mean(mean(mean(img)));
 rawdata(i) = img;
 img = img - baseline;
 offsetdata(i) = img;
 scatter(i,img); hold on;
 pause(0.01);

end

raw_mean = mean(rawdata(20:end));
raw_std = std(rawdata(20:end));
data_mean = mean(offsetdata(20:end));
data_std = std(offsetdata(20:end));

Saveme.raw_mean = raw_mean;
Saveme.raw_std = raw_std;
Saveme.data_mean = data_mean;
Saveme.data_std = data_std;
Saveme.rawdata = rawdata;
Saveme.data = offsetdata;

fff = figure(3)
scatter(j,Saveme.data_mean);

save(['mydata_',int2str(j),'_.mat'],'Saveme');
input('HIt enter to continue... ')

end


%Shuts down camera
clear('cam')