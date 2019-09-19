%Initialization step
clear all;close all;clc;

%Simulation propoerties
NCycles = 50;                % WE WILL Search for ideal hologram for that many cycles
lambda = 1.0E-6;            % wavelength [m]
ps = 10.0E-6;               % Pixel Size [m]
focallength = 0.1
% Import Two frames image1 and image2
[FrameA] = function_graypicinput('Image1.jpg');
Error = zeros(1,NCycles);

%Create coordinates and mesh axis for fast calculation
[LX,LY] = size(FrameA);
UX = 1:LX;UX = UX*ps;UX = UX-mean(UX);
UY = 1:LY;UY = UY*ps;UY = UY-mean(UY);
[XX,YY] = ndgrid(UX,UY);


%Initialize Amplitude and phase in z = 0 
Amplitude = sqrt(FrameA);
%Phase = 2*pi*rand(LX,LY);
Phase = 2*pi*zeros(LX,LY);
% Compute Initial complex field
Field1 = Amplitude.*exp(1i*Phase);


%Run simulation : in NCycle Steps : 
for j = 1:NCycles
f = figure(1);
subplot(2,3,1)
imagesc(1000*UX,1000*UY,abs(Field1').^2); 
axis image; 
xlabel('x,[mm]'); ylabel('y [mm]');
title('Intensity at z=0 [AU]'); colorbar;
subplot(2,3,4)
imagesc(1000*UX,1000*UY,angle(Field1')); 
axis image; 
xlabel('y,[mm]'); ylabel('x [mm]');
title('phase at z = 0 [AU]'); colorbar

% Start by calculating propagated field at a distance z
[Field2,psX,psY] = function_lens(Field1,ps,ps,focallength,lambda);

%Display propagated field
f = figure(1);
subplot(2,3,2)
imagesc(1000*UX,1000*UY,abs(Field2').^2); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['Intensity at hologram  [AU]']); 
colorbar;
subplot(2,3,5)
imagesc(1000*UX,1000*UY,angle(Field2')); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['phase at hologram  [AU]']);
colorbar
drawnow
pause(0.01) % Wait 0.1 seconds




% Let's update the amplitude in Field 2 
Phase = angle(Field2);
NewAmplitude = ones(LX,LY);
Field2 = NewAmplitude.*exp(1i*Phase);

% Let's propagate back 
[Field1,ps,ps] = function_lens(Field2,psX,psX,focallength,lambda);
Field1 = flipud(fliplr(Field1));

f = figure(1);
subplot(2,3,3)
imagesc(1000*UX,1000*UY,abs(Field1').^2); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['Intensity at hologram  [AU]']); 
colorbar;
subplot(2,3,5)
imagesc(1000*UX,1000*UY,angle(Field1')); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['phase at hologram  [AU]']);
colorbar
drawnow

% Let's update the amplitude in Field 1 
Phase = angle(Field1);
NewAmplitude = sqrt(FrameA);
Field1 = NewAmplitude.*exp(1i*Phase);
end

