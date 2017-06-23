Img1FileName = 'left.pgm';
Img2FileName = 'right.pgm';
[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.5);
DisplayCorr(imread(Img1FileName), imread(Img2FileName), matches, dist_vals, 10)