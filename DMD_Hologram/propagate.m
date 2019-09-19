function [field2] = propagate(field1,lambda,z,ps)
% This function simulates the paraxial propagation of a complex 2D field 
% field1 is the x,y complex field (amplitude .* exp(i*phase)) at z=0,
% sampled on a grid of pixel size ps
% ps is the pizel size 
% lambda the wavelength 
% z is the desired propagation distance 

% Function returns field2, thecomplex field at distance z


% adapted from previous work by Laura Waller, MIT, lwaller@alum.mit.edu
% Nicolas Pegard

[M,N]=size(field1);
[x,y]=meshgrid(-N/2+1:N/2, -M/2+1:M/2);
fx=x/ps/N;     
fy=y/ps/M;     
H=exp(-1i*pi*lambda*z.*(fx.^2+fy.^2));
objFT=fftshift(fft2(field1));
field2=(ifft2(fftshift(objFT.*H)));
end