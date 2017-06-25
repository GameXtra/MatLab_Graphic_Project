function [H] = RANSAC_Wrapper(matches, fittingfn, ...
    distfn, degenfn, s, t, feedback, maxDataTrials, ...
    maxTrials)
        if nargin < 9; maxTrials = 1000;        end
        if nargin < 8; maxDataTrials = 100;     end
        if nargin < 7; feedback = 0;            end

        if size(matches, 1) < 4 || s<4
            disp(s);
            disp(matches);
            error('You need at least 4 points for a homography');
        end
        
        if size(matches, 2) == 6
            x1 = matches(:,1:3);
            x2 = matches(:,4:6);
        elseif size(matches, 2) == 4
            x1 = matches(:,1:2);
            x1(:,3) = ones(size(x1,1),1);
            x2 = matches(:,3:4);
            x2(:,3) = ones(size(x2,1),1);
        else
           disp(matches);
           error("Matches is wrong (need to have 4 or 6 columns");
        end
        
        [x1, T1] = normalisePoints(x1);
        [x2, T2] = normalisePoints(x2);
        x1=x1';x2=x2';
        x = [x1; x2];
        fittingfn = @(x) fittingfn(x');
        distfn = @(M, x, t) distfn(M, x', t);
        degenfn = @(x) degenfn(x');
        
        [H, inliers] = ransac(x, fittingfn, distfn, degenfn, s, t, feedback, ...
                               maxDataTrials, maxTrials);        
                           
        fprintf("found %d inlines out of %d points\n", [length(inliers), size(x,2)]);
        x = x';
        x = x(inliers, :);
        H = DLT(x); %get the best H with all the inlines (for less error).
        H = T2\H*T1;
end