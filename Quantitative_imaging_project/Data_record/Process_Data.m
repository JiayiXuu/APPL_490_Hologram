clear all
close all
clc

names = {'LED_and_DARK_PointSource_10CM.mat','LED_and_DARK_PointSource_30CM_FIXED_CALIBRATED.mat','LED_and_DARK_PointSource_30CM_FIXED_CALIBRATED.mat'}
for j = 1 : numel(names)
   load(names{j});
   f = figure(1)
   subplot(1,2,1)
   scatter(j,Saveme.data_mean); hold on ; title('Mean')
   subplot(1,2,2)
   scatter(j,Saveme.data_std); hold on; title('St dev')
   

end
    

