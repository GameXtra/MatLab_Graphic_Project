% this script shows a case where ransac DOES improve upon the DLT
% result.

Img1FileName = 'ferrariGrayScale.pgm';
Img2FileName = 'transformedFerrari.pgm';

[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.7);
res = DisplayCorr(imread(Img1FileName), imread(Img2FileName), matches, dist_vals, 10);

% this image has significant outliers! 
% imshow(res);
% title('note the outliers 4,10');

dltH = DLT(matches);
ransacH = RANSAC_Wrapper(matches, @DLT, ...
    @getHomographicDist, @(x) 0, 4, 0.0005, false, 100, 100000);

predictionDLT = ComputeProjective(imread(Img1FileName),dltH);
predictionRansac = ComputeProjective(imread(Img1FileName),ransacH');

figure, imshow(res)
title('note the outliers 4,10');

figure, imshow(predictionDLT)
title('bad result for DLT')

figure, imshow(predictionRansac)
title('good result for RANSAC')

% imshow(compare);
% title('note the major difference in results');