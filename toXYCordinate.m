function [points] = toXYCordinate(originalPoints)
    if size(originalPoints, 2) == 2
        points = originalPoints;
        return;
    elseif size(originalPoints,2) ~= 3
        error("the input points are wrong");
    else
        points = zeros(size(originalPoints,1),2);
        for i = 1 : size(originalPoints,1)
            points(i,1) = originalPoints(i,1)/originalPoints(i,3);
            points(i,2) = originalPoints(i,2)/originalPoints(i,3);
        end
    end
    
end