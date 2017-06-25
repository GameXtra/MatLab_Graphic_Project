function [pnts_gt,pnts_computed] = ComputeTestPoints(H_gt,H_computed)
    pointToCompute = 300000;
    original_points = rand([pointToCompute,3]);
    
    original_points(:,3) = ones(size(original_points,1),1);
    
    pnts_gt = (H_gt' * original_points')';
    pnts_gt = num2cell(pnts_gt, 2);            %# Collect the rows into cells
    pnts_gt = cellfun(@(x) [x(1)/x(3), x(2)/x(3)] , pnts_gt , 'UniformOutput', false);
    pnts_gt = cell2mat(pnts_gt);
    
    pnts_computed = (H_computed' * original_points')';
    pnts_computed = num2cell(pnts_computed, 2);            %# Collect the rows into cells
    pnts_computed = cellfun(@(x) [x(1)/x(3), x(2)/x(3)] , pnts_computed,'UniformOutput', false);
    pnts_computed = cell2mat(pnts_computed);
    
end

