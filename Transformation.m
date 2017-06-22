Img = imread('vampire-bat-blood-taste-buds-01.jpg');
H = [1 .2 0; .1 1 0; 0.5 0.2 1];
imshow(ComputeProjective(Img, H));





function [TransformIm] = ComputeProjective(Im, H)
    T = maketform('projective',H);
    TransformIm = imtransform(Im,T);
end

