function [H_ransac] = RANSAC_Wrapper(matches, fittingfn, ...
    distfn, degenfn, s, t, feedback, maxDataTrials, ...
    maxTrials)
        distfn = distfn_fit_ransac_needs(distfn);
        
        [H_ransac, inliers] = ransac(matches', fittingfn, distfn, degenfn, s, t, feedback, ...
                               maxDataTrials, maxTrials);
end

function f = distfn_fit_ransac_needs(distfn)
    f = @(M, x, t) distfn_with_inliners(distfn, M, x', t);
end

function [inliers, RetH] = distfn_with_inliners(distfn, H, matches, t)
    if ~isempty(H)
        if size(H,3) ~= 1 % number of matrixes options, need to return the min one.
            inliersMaxValue = 0;
            for i = 1 : size(H,1)
               [curInliers, curH] = distfn_with_inliners(distfn, H(i,:,:), matches, t);
               lengthCurInliers = length(curInliers);
               if lengthCurInliers > inliersMaxValue && (~isempty(curH))
                    inliersMaxValue = lengthCurInliers;
                    inliers = curInliers;
                    RetH = curH;
               elseif lengthCurInliers == inliersMaxValue && (~isempty(curH))
                    [inliers1, error1] = getHInfo(distfn, curH, matches, t);    
                    [inliers2, error2] = getHInfo(distfn, RetH, matches, t);
                    if length(inliers2>0) <= length(inliers1>0) && error2 < error1
                        inliers = curInliers;
                        RetH = curH;
                    end
               end
            end
        else
            RetH = H;
            [inliers, error] = getHInfo(distfn, H, matches, t);
        end
    end
end

function [inliers, error] = getHInfo(distfn, H, matches, t)
            original_points = matches(:,1:2);
            original_points(:,3) = ones(size(original_points,1),1);
            
            pnts_computed = (H' * original_points')';
            pnts_gt = matches(:,3:4);
            
            pnts_computed = num2cell(pnts_computed, 2);            %# Collect the rows into cells
            pnts_computed = cellfun(@(x) [x(1)/x(3), x(2)/x(3)] , pnts_computed,'UniformOutput', false);
            pnts_computed = cell2mat(pnts_computed);

            distance_between_pnts_computed = pnts_gt - pnts_computed;
            distance_between_pnts_computed = num2cell(distance_between_pnts_computed, 2);            %# Collect the rows into cells
            distance_between_pnts_computed = cellfun(@(x) sqrt(x(1)*x(1) + x(2)*x(2)) , distance_between_pnts_computed);
            row1 = 1;
            inliers = zeros(sum((distance_between_pnts_computed < t)),1);
            for i = 1: size(distance_between_pnts_computed, 1)
                if (distance_between_pnts_computed(i) < t)
                    inliers(row1) = i;
                    row1 = row1 + 1;
                end
            end
            
            error = distfn(pnts_gt,pnts_computed);
end