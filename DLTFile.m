matches = [230.67,749.49 ,285.83,708.2;
248.53,531.28 ,273.34,512.68;
255.8,437.17 , 267.88,428.72;
443.97,646.63 , 450.77,641.47;
659.47,539.78 , 617.06,570.51;
373.41,758.65 ,406.33,735.67;
166.58,855.98 , 245.88,797.93;
380.97,758.03 , 412.41,735.71;
361.86,713.22 , 392.86,696.62;
392.31,649.38 , 407.89,638.14]

normalizedMatches = DLT(matches)
%disp(normalizedMatches)
%disp(mean(normalizedMatches))


function [H] = DLT(matches)
    % stages: (1),(2) 
    [numRows , numColumns] = size(matches)

    columnMeans = mean(matches,1)
    x1Mean = columnMeans(1);
    y1Mean = columnMeans(2);
    x2Mean = columnMeans(3);
    y2Mean = columnMeans(4);

    wValue = 1;
    wColumn(1:numRows) = wValue;
    
    points1 = zeros(numRows, 3);
    points1(:,1:2) = matches(:,1:2);
    points1(:,3) = wColumn;

    points2 = zeros(numRows, 3);
    points2(:,1:2) = matches(:,3:4);
    points2(:,3) = wColumn;

    T1translate = [1,0,0; 0,1,0; -x1Mean, -y1Mean,1];
    T2translate = [1,0,0; 0,1,0; -x2Mean, -y2Mean,1];

    disp(points1)
    disp(points2)
    disp(points1 * T1translate)
    disp(points2 * T2translate)

    
    %find average length of points x1 y1:    
    points1LengthSum = 0;
    for row  = 1:numRows
            X = [0,0; matches(row,1),matches(row,2)];
            points1LengthSum = points1LengthSum + pdist(X,'euclidean')
    end
    points2LengthSum = 0;
    for row  = 1:numRows
            X = [0,0; matches(row,3),matches(row,4)];
            points2LengthSum = points2LengthSum + pdist(X,'euclidean')
    end

    averageLengthPoints1 = points1LengthSum / numRows;
    averageLengthPoints2 = points2LengthSum / numRows;

    c1 = sqrt(2)/averageLengthPoints1;
    c2 = sqrt(2)/averageLengthPoints2;
    T1scale = [c1,0,0; 0,c1,0; 0,0,1];
    T2scale = [c2,0,0; 0,c2,0; 0,0,1];

    % for testing:
    %T1scale = [10,0,0; 0,10,0; 0,0,1];
    %T1translate = [1,0,0; 0,1,0; -10, -10,1];
    
    T1 = T1translate*T1scale;
    T2 = T2translate*T2scale;
    
    %disp(points1*T1)
    
    normalizedPoints1 = points1*T1;
    normalizedPoints2 = points1*T2;
    
    % stage: (3)
    A = zeros(2*numRows, 9)
    for i=1:numRows
        x2 = points2(i,1);
        y2 = points2(i,2);
        w2 = points2(i,3);
        
        x1 = points1(i,1);
        y1 = points1(i,2);
        w1 = points1(i,3);
        
        Ai = [0,0,0,-w2*x1,-w2*y1,-w2*w1,y2*x1,y2*y1,y2*w1;
              w2*x1,w2*y1,w2*w1,0,0,0,-x2*x1,-x2*y1,-x2*w1];  

        
    end
    %temporary, delete this!!
    H = matches
end