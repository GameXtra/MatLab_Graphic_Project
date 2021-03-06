function [num_matches, matches, dist_vals] = match(image1, image2, distRatio)

% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results #################### use distance euclean instead of dot prroduct
    
   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
      dist(i) = vals(1) / vals(2);%sqrt(sum((des1(i,:) - des2(indx(1),:)) .^ 2)) / sqrt(sum((des1(i,:) - des2(indx(2),:)) .^ 2));
   else
      dist(i) = 0;
      match(i) = 0;
   end
end


num_matches = sum(match > 0);
matches = zeros(num_matches, 4);
dist_vals = zeros(num_matches, 1);

row1 = 1;
for i = 1: size(des1,1)
  if (match(i) > 0) %notice that for some reson locs are (y,x) instead of (x,y).
      matches(row1, 1) = loc1(i,2);
      matches(row1, 2) = loc1(i,1);
      matches(row1, 3) = loc2(match(i),2);
      matches(row1, 4) = loc2(match(i),1);
      dist_vals(row1) = dist(i);
      row1 = row1 + 1;
  end
end
fprintf('Found %d matches.\n', num_matches);