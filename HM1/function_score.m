function [score] = function_score(IntensityA,IntensityB)
%Score indicating how well Intensity A and B are matching

%Eliminate nonzero background
IntensityA=IntensityA-min(IntensityA(:));
IntensityB=IntensityB-min(IntensityB(:));

%normalize the two input intensity profiles
IntensityA=IntensityA/sum(IntensityA);
IntensityB=IntensityB/sum(IntensityB);

%Calculate the error image with an L2 norm
errorimage = sqrt((IntensityA-IntensityB).^2);

%Mean value over the whole image
score = mean(errorimage(:));


end

