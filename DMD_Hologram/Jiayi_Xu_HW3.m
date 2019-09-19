%This resets the environment 
clear all; close all; clc;

%Define simulation propoerties
lambda = 1.0E-6; % wavelength [m]
ps = 10.0E-6; % Pixel Size [m]
LX = 400; % Number of data points laong X axis
LY = 400; % Number of data points laong Y axis

%Define simulation environment : propagation axis
NZ = 51; % Number of points along Z axis
radius = 0.05;
z = linspace(0,radius, NZ); % Define the axis of depths to use [m]

%Create coordinates and mesh axis for fast calculation
UX = 1:LX;UX = UX*ps;UX = UX-mean(UX);
UY = 1:LY;UY = UY*ps;UY = UY-mean(UY);
[XX,YY] = ndgrid(UX,UY);

%%%%%% EDIT BELOW THIS LINE ONLY
%Build a source by defining Amplitude and Phase here, 
%Hint : use XX, and YY 



Phase = (2*pi/lambda)*(radius - (XX.^2 + YY.^2)/(2*radius));
r = 0.001;
Amplitude = exp(-(XX.^2 + YY.^2) / (r^2));                                                                                                                                                               


%%%%%% EDIT ABOVE THIS LINE ONLY


%Do not edit further
% Compute Input ocmplex field
Field1 = Amplitude.*exp(1i*Phase);

%visualize input field, intensity and phase
f = figure(1);
subplot(2,2,1)
imagesc(1000*UX,1000*UY,abs(Field1').^2); 
axis image; 
xlabel('x,[mm]'); ylabel('y [mm]');
title('Intensity at z=0 [AU]'); colorbar;
subplot(2,2,2)
imagesc(1000*UX,1000*UY,angle(Field1')); 
axis image; 
xlabel('y,[mm]'); ylabel('x [mm]');
title('phase at z = 0 [AU]'); colorbar

%Run simulation : in NZ steps : 
for j = 1:NZ
    % Start by calculating propagated field at a distance z(j)
[Field2] = propagate(Field1,lambda,z(j),ps);

%Display propagated field
f = figure(1);
subplot(2,2,3)
imagesc(1000*UX,1000*UY,abs(Field2').^2); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
caxis([0 max(max(abs(Field2').^2))])
title(['Intensity at z = ' int2str(abs(1000*z(j))) 'mm [AU]']); 
colorbar;

subplot(2,2,4)
imagesc(1000*UX,1000*UY,angle(Field2')); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['phase at z = ' int2str(abs(1000*z(j))) 'mm [AU]']);
colorbar
drawnow
pause(0.001) % Wait 0.1 seconds
end
