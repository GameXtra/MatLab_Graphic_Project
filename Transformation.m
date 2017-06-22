Img1FileName = 'left.pgm';
Img2FileName = 'right.pgm';
[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.6);
matches;
dist_vals;



function [TransformIm] = ComputeProjective(Im, H)
    T = maketform('projective',H);
    TransformIm = imtransform(Im,T);
end