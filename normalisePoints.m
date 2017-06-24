function [normalizedPoints, T] = normalisePoints(pts)
    % if pts are 3 x,y,w array.
    pts = toXYCordinate(pts);
    
    % stages: (1),(2) 
    [numRows , numColumns] = size(pts);

    columnMeans = mean(pts,1); %array with mean per column
    x1Mean = columnMeans(1);
    y1Mean = columnMeans(2);

    %add 1s column to each set of points
    wValue = 1;
    wColumn(1:numRows) = wValue;
 
    points1 = zeros(numRows, 3);
    points1(:,1:2) = pts(:,1:2);
    points1(:,3) = wColumn;
   
    %will move point's mean to (0,0):
    T1translate = [1,0,0; 0,1,0; -x1Mean, -y1Mean,1]';
    
    %find average length of points x1 y1:
    points1LengthSum = 0;
    for row  = 1:numRows
            X = [0,0; pts(row,1),pts(row,2)];
            points1LengthSum = points1LengthSum + pdist(X,'euclidean');
    end

    averageLengthPoints1 = points1LengthSum / numRows;

    %will scale so average length of vector is sqrt(2):
    c1 = sqrt(2)/averageLengthPoints1;
    T1scale = [c1,0,0; 0,c1,0; 0,0,1]';
    
    % for testing:
%     T1scale = [10,0,0; 0,10,0; 0,0,1]';
%     T1translate = [1,0,0; 0,1,0; -10, -10,1]';
    
    T = T1scale*T1translate;

    normalizedPoints = (T*points1')';
end

