%Initialization step
clear all;close all;clc;

%Simulation propoerties
NCycles = 50;                % WE WILL Search for ideal hologram for that many cycles
lambda = 1.0E-6;            % wavelength [m]
ps = 0.5E-6;               % Pixel Size [m]
focallength = 0.1;
% Import Two frames image1 and image2
[FrameA] = function_graypicinput('Image1.jpg');
FrameA = imresize(FrameA,[180,180]);
FrameA = padarray(FrameA,[200 200],0,'both');


%Create coordinates and mesh axis for fast calculation
[LX,LY] = size(FrameA);
UX = 1:LX;UX = UX*ps;UX = UX-mean(UX);
UY = 1:LY;UY = UY*ps;UY = UY-mean(UY);
[XX,YY] = ndgrid(UX,UY);

%Initialize Amplitude and phase in z = 0 
Amplitude = sqrt(FrameA);
Phase = 2*pi*rand(LX,LY);
Field1 = Amplitude.*exp(1i*Phase);

%Run simulation : in NCycle Steps : 
for j = 1:NCycles
% Start by calculating propagated field At the SLM
[Field2,psX,psY] = function_lens(Field1,ps,ps,focallength,lambda);

%Display propagated field
f = figure(1);
subplot(2,2,3)
imagesc(1000*UX,1000*UY,abs(Field2').^2); axis image; xlabel('x,[mm]');ylabel('y [mm]');title(['Intensity at SLM  [AU]']); colorbar;
subplot(2,2,4)
imagesc(1000*UX,1000*UY,angle(Field2')); axis image; xlabel('x,[mm]');ylabel('y [mm]');title(['phase at SLM  [AU]']);colorbar;drawnow;

% Let's update the amplitude in Field 2 
Phase = angle(Field2);
NewAmplitude = ones(LX,LY);
Field2 = NewAmplitude.*exp(1i*Phase);

% Let's propagate back 
[Field1,ps,ps] = function_lens(Field2,psX,psX,focallength,lambda);
Field1 = flipud(fliplr(Field1));

f = figure(1);
subplot(2,2,1)
imagesc(1000*UX,1000*UY,abs(Field1').^2); axis image; xlabel('x,[mm]');ylabel('y [mm]');title(['Intensity at Object  [AU]']); colorbar;
subplot(2,2,2)
imagesc(1000*UX,1000*UY,angle(Field1')); axis image; xlabel('x,[mm]');ylabel('y [mm]');title(['phase at Object  [AU]']);colorbar;
drawnow

% Let's update the amplitude in Field 1 
Phase = angle(Field1);
NewAmplitude = sqrt(FrameA);
Field1 = NewAmplitude.*exp(1i*Phase);
end
result.Phase = Phase;
% 1 - Pickup the phase of the Hologram you would make if you had an SLM at
% the end of the GS Sequence (Hint, you can pick it up at all steps of the
% loop. Call this Phase (an NX by NY matrix of values between 0 and 2 pi)
% "Result.Phase"

%At this point we solved for a conventional hologram in the Fourier domain.
refangle = 20*pi/180; % 3 degrees in radians

%2 - Create a reference wave called "ReferenceWave" that propagates at an angle "refangle" along the z axis towards the y axis 
Referencewave = exp(1i * 2 * pi * refangle * YY / lambda);
%3 - The Hologram is the interference pattern between the GS-Solution at the
%SLM and a reference wave, by adding the complex amplitudes, create the quantity "Hologram"
Hologram = Referencewave + exp(1i * result.Phase);
%Display intermediate steps
f = figure(2);
imagesc(abs(Hologram));
title('Hologram');
% Will display the amplitude of the hologram (otice interference pattern

%4 -  Now to simulate DMD effects, take the amplitude of the hologram,
%Normalize and round to a vlaue that is either 0 or 1 to acocunt for
%amplitude modulation "All or nothing" at the DMD
Hologram = abs(Hologram);
Hologram = Hologram / (max(Hologram(:)));
Hologram = round(Hologram);

%Display intermediate steps
f = figure(2);
imagesc(abs(Hologram));
title('Pattern on DMD');
% Will now display the amplitude of the hologram (otice interference pattern


% 5 - Now we simulate the diffraction of the conjugate ReferenceWave on the
% DMD hologram. Calculate the complex field leaving the DMD. Call it "DMDHologram"
DMDHologram = conj(Referencewave) .* Hologram;

% We can then send the DMDHolgoram through the lens and see if we
% reconstruct the data
[Field1,ps,ps] = function_lens(DMDHologram,psX,psX,focallength,lambda);
Field1 = flipud(fliplr(Field1));
g = figure(2);
imagesc(1000*UX,1000*UY,log(abs(Field1').^2)); 
axis image; 
xlabel('x,[mm]');ylabel('y [mm]');
title(['Log-Intensity at hologram  [AU]']); 
