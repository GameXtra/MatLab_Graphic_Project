function [TransformIm] = ComputeProjective(Im, H)
    T = maketform('projective',H);
    TransformIm = imtransform(Im,T);
end