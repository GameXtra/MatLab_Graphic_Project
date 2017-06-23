function [pnts_gt,pnts_computed] = ComputeTestPoints(H_gt,H_computed)
    pointToCompute = 1000;
    original_points = rand([pointToCompute,3]);
    pnts_gt = zeros([pointToCompute,2]);
    pnts_computed = zeros([pointToCompute,2]);
    
    for i = 1: pointToCompute
        original_points(i,1) = original_points(i,1) * 1000;
        original_points(i,2) = original_points(i,2) * 1000;
        original_points(i,3) = 1;
        
        v0 = original_points(i,:);
        v1  = H_gt' *  v0';
        v2  = H_computed' *  v0';
        
        pnts_gt(i, :) = [v1(1)/v1(3) v1(2)/v1(3)];
        pnts_computed(i, :) = [v2(1)/v2(3) v2(2)/v2(3)];
    end 
end

