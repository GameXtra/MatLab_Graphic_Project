% matches = [230.67,749.49 ,285.83,708.2;
% 248.53,531.28 ,273.34,512.68;
% 255.8,437.17 , 267.88,428.72;
% 443.97,646.63 , 450.77,641.47;
% 659.47,539.78 , 617.06,570.51;
% 373.41,758.65 ,406.33,735.67;
% 166.58,855.98 , 245.88,797.93;
% 380.97,758.03 , 412.41,735.71;
% 361.86,713.22 , 392.86,696.62;
% 392.31,649.38 , 407.89,638.14];

Img1FileName = 'left.pgm';
Img2FileName = 'right.pgm';
[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.5);

H = DLT(matches);
T = maketform('projective',H);
I = imread('left.pgm');

%imshow(I);
I2 = imtransform(I,T);
figure, imshow(I2)

function [H] = DLT(matches)
    % stages: (1),(2) 
    [numRows , numColumns] = size(matches);

    columnMeans = mean(matches,1); %array with mean per column
    x1Mean = columnMeans(1);
    y1Mean = columnMeans(2);
    x2Mean = columnMeans(3);
    y2Mean = columnMeans(4);
    
    %add 1s column to each set of points
    wValue = 1;
    wColumn(1:numRows) = wValue;
 
    points1 = zeros(numRows, 3);
    points1(:,1:2) = matches(:,1:2);
    points1(:,3) = wColumn;
    
    disp("LOOK HERE")

    points2 = zeros(numRows, 3);
    points2(:,1:2) = matches(:,3:4);
    points2(:,3) = wColumn;
    
    %will move point's mean to (0,0):
    T1translate = [1,0,0; 0,1,0; -x1Mean, -y1Mean,1]';
    T2translate = [1,0,0; 0,1,0; -x2Mean, -y2Mean,1]';
    
    %find average length of points x1 y1:
    points1LengthSum = 0;
    for row  = 1:numRows
            X = [0,0; matches(row,1),matches(row,2)];
            points1LengthSum = points1LengthSum + pdist(X,'euclidean');
    end
    points2LengthSum = 0;
    for row  = 1:numRows
            X = [0,0; matches(row,3),matches(row,4)];
            points2LengthSum = points2LengthSum + pdist(X,'euclidean');
    end

    averageLengthPoints1 = points1LengthSum / numRows;
    averageLengthPoints2 = points2LengthSum / numRows;

    %will scale so average length of vector is sqrt(2):
    c1 = sqrt(2)/averageLengthPoints1;
    c2 = sqrt(2)/averageLengthPoints2;
    T1scale = [c1,0,0; 0,c1,0; 0,0,1]';
    T2scale = [c2,0,0; 0,c2,0; 0,0,1]';
    
    % for testing:
    %T1scale = [10,0,0; 0,10,0; 0,0,1]';
    %T1translate = [1,0,0; 0,1,0; -10, -10,1]';
    
    T1 = T1scale*T1translate;
    T2 = T2scale*T2translate;

    normalizedPoints1 = (T1*points1')';
    normalizedPoints2 = (T2*points2')';
    
    % stages: (3)(4)
    A = zeros(2*numRows, 9);
    for i=1:numRows
        x2 = normalizedPoints2(i,1);
        y2 = normalizedPoints2(i,2);
        w2 = normalizedPoints2(i,3);
        
        x1 = normalizedPoints1(i,1);
        y1 = normalizedPoints1(i,2);
        w1 = normalizedPoints1(i,3);
        
        Ai = [0,0,0,-w2*x1,-w2*y1,-w2*w1,y2*x1,y2*y1,y2*w1;
              w2*x1,w2*y1,w2*w1,0,0,0,-x2*x1,-x2*y1,-x2*w1];  
        
        A((i*2)-1:i*2,1:9) = Ai;        
    end    
    disp(A)

    %stage: (5)
    svdA = svd(A);

    %stage: (6)
    H = vec2mat(svdA,3);
    disp(H)
    disp("????")
    H = (inv(T2)*H*T1)';
    H = T1translate;
end