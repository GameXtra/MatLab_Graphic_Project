function [H_ransac] = RANSAC_Wrapper(matches, fittingfn, ...
    distfn, degenfn, s, t, feedback, maxDataTrials, ...
    maxTrials)
        distfn = distfn_fit_ransac_needs(distfn);
        
        [H_ransac, inliers] = ransac(matches, fittingfn, distfn, degenfn, s, t, feedback, ...
                               maxDataTrials, maxTrials);
end

function f = distfn_fit_ransac_needs(distfn)
    f = @(M, x, t) distfn_with_inline(distfn, M, x, t);
end

function [inliers, RetH] = distfn_with_inline(distfn, H, matches, t)
    if size(H,1) ~= 0
        if size(H,3) ~= 1 % number of matrixes options, need to return the min one.
            inliersMinValue = Inf;
            for i = 1 : size(H,1)
               [curInliers, curH] = distfn_with_inline(distfn, H(i,:,:), matches, t);
               sumCurInliers = sum(curInliers);
               if sumCurInliers < inliersMinValue && size(curH,1) ~= 0
                    inliersMinValue = sumCurInliers;
                    inliers = curInliers;
                    RetH = curH;
               end
            end
        else
            RetH = H;
            original_points = matches(:,1:2);
            original_points(:,3) = ones(size(original_points,1),1);
            pnts_computed = (H' * original_points')';
            pnts_gt = matches(:,3:4);
            pnts_gt(:,3) = ones(size(pnts_gt,1),1);
          
            pnts_gt = num2cell(pnts_gt, 2);                        %# Collect the rows into cells
            pnts_gt = cellfun(@(x) [x(1)/x(3), x(2)/x(3)] , pnts_gt , 'UniformOutput', false);
            pnts_gt = cell2mat(pnts_gt);

            pnts_computed = num2cell(pnts_computed, 2);            %# Collect the rows into cells
            pnts_computed = cellfun(@(x) [x(1)/x(3), x(2)/x(3)] , pnts_computed,'UniformOutput', false);
            pnts_computed = cell2mat(pnts_computed);

            distance_between_pnts_computed = pnts_gt - pnts_computed;
            distance_between_pnts_computed = num2cell(distance_between_pnts_computed, 2);            %# Collect the rows into cells
            distance_between_pnts_computed = cellfun(@(x) sqrt(x(1)*x(1) + x(2)*x(2)) , distance_between_pnts_computed);
            inliers = (distance_between_pnts_computed < t);

        end
    end
end