function [inliers, H] = getHomographicDist(H, matches, t)
            if size(matches,2) == 6
                x1 = toXYCordinate(matches(:,1:3));
                x2 = toXYCordinate(matches(:,4:6));
            elseif size(matches,1) == 4
                x1 = matches(:,1:2);
                x2 = matches(:,3:4);
            else
                disp(matches);
                error('unknown data');
            end

            original_points = x1;
            original_points(:,3) = ones(size(original_points,1),1);
            
            pnts_computed = (H' * original_points')';
            pnts_gt = x2;
            
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
end
