 %code 
fileFolder = fullfile(matlabroot, 'toolbox', 'images', 'imdata');
dirOutput = dir('');
fileNames = {dirOutput.name}'
numFrames = numel(fileNames)
I = imread(fileNames{1});
sequence =  zeros([size(I) numFrames], class(I));
sequence(:,:,1) = I;
% 
for p = 1:numFrames
    sequence(:,:,p) = imread(fileNames{p});  
end
sequenceNew = stdfilt(sequence, ones(3));

    for d = 0001:numFrames
        %intensity plot info
        Int = imread(fileNames{d});
        [x,y] = size(Int);
        X = 1:x;
        Y = 1:y;
        [xx,yy] = meshgrid(Y,X);
        i = im2double(Int);
        %max coordinates and FWHM x and y from plot
        [mz,k] = max(i(:));
        mhz = 0.5*mz;
        [ix,iy] = ind2sub(size(i),k);
        [minhalfdiff, poshalfdiff] = min(abs(i - mhz));
        [ihx, ihy] = ind2sub(size(i), poshalfdiff);
        halfwidth = sqrt((ihx - ix).^2 + (ihy - iy).^2);
        [ix,jy,mz];
        %max intensity coordinates in microns
        %pixel size is 6.45x6.45 microns
        ix = 6.45*ix;
        jy = 6.45*jy;
        [ix,jy,mz];
        mhz = 0.5*mz;
        hk = 0.5*k;
        [ihx,jhy]=ind2sub(size(i),hk);
        [ihx,jhy,mhz];
        FWHMx = abs(ix-ihx)*2;
        FWHMy = abs(jy-jhy)*2;
        %table of data from plot
        f = figure;
        data = [ix,jy,mz,FWHMx,FWHMy];
        colnames = {'X(Zmax) [um]', 'Y(Zmax) [um]', ...
            'Zmax/Max Intensity', 'FWHMx [um]', 'FWHMy [um]'};
        t = uitable(f, 'Data', data, 'ColumnName', colnames, 'ColumnWidth', {120});
        t.Position(3) = t.Extent(3);
        t.Position(4) = t.Extent(4);
        %make subplot of table and intensity plot
        subplot(2,1,1) = mesh(xx,yy,i); colorbar;
        title('Intensity of Beam Image as a Function of Pixel Position');
        xlabel('X(pixels)');
        ylabel('Y (pixels)');
        zlabel('Intensity (double precision corrected) [a.u.]');
        pos = get(subplot(2,1,2, 'position'));
        delete(subplot(2,1,2))
        set(t,'units','normalized')
        set(t, 'position', pos)
    end
    test = 1
end