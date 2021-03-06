% Img1FileName = 'left.pgm';
% Img2FileName = 'right.pgm';
% [num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.5);
% res = DisplayCorr(imread(Img1FileName), imread(Img2FileName), matches, dist_vals, 10);
% H=[1 .2 0; .1 1 0; 0.5 0.2 1];
% H1=[2 .2 0; 0 1 0; 1 1 1];
% H2=[2 0 0; 0 2 0; 6 2 1];
% [pnts_gt,pnts_computed] = ComputeTestPoints(H , H1);
% ans1 = ComputeError(pnts_gt,pnts_computed);
% [pnts_gt,pnts_computed] = ComputeTestPoints(H , H2);
% ans2 = ComputeError(pnts_gt,pnts_computed);
% %[pnts_gt,pnts_computed] = ComputeTestPoints(H,H1); ComputeError(pnts_gt,pnts_computed);
Img1FileName = 'left.pgm';
Img2FileName = 'right.pgm';
[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.29);

newH = DLT(matches);
disp(newH);

imshow(ComputeProjective(imread(Img2FileName),newH));



% [displayedCorr] = DisplayCorr(imread(Img1FileName), imread(Img2FileName), matches, dist_vals, 10);
% imshow(displayedCorr);