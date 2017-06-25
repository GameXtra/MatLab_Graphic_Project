Img1FileName = 'left.pgm';
Img2FileName = 'right.pgm';

[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.5);

[H] = RANSAC_Wrapper(matches, @DLT, ...
    @getHomographicDist, @(x) 0, 4, 0.0002, true);

Im = imread('left.pgm');
I2 = ComputeProjective(Im, H');
I3 = appendimages(imread('right.pgm'), I2);
imshow(I3);


        fittingfn = @(x) DLTFile(x'); % @homography2d;
        distfn    = @(M, x, t) getHInfo(M, x', t); %@homogdist2d
        degenfn   = @(x) 0;%@isdegenerate;