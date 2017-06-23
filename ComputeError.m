function [error] = ComputeError(pnts_gt,pnts_computed)
    error = 0;
    for i = 1 : size(pnts_gt, 1)
        error = error + EuclideanDistance(pnts_gt(i, :), pnts_computed(i, :));
    end
    error = error / size(pnts_gt, 1);
end

function [D] = EuclideanDistance(G,G2)
    V = G - G2;
    D = sqrt(V * V');
end