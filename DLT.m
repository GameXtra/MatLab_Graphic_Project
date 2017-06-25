function [H] = DLT(matches)
    [numRows , numColumns] = size(matches);
    %stages: (1)(2)
    if numColumns == 4
        [normalizedPoints1, T1] = normalisePoints(matches(:,1:2));
        [normalizedPoints2, T2] = normalisePoints(matches(:,3:4));
    elseif numColumns == 6
        [normalizedPoints1, T1] = normalisePoints(matches(:,1:3));
        [normalizedPoints2, T2] = normalisePoints(matches(:,4:6));
    else
        error("points should be x,y,w , or x,y");
    end

    % stages: (3)(4)
    A = zeros(2*numRows, 9);
    for i=1:numRows
        x2 = normalizedPoints2(i,1);
        y2 = normalizedPoints2(i,2);
        w2 = normalizedPoints2(i,3);
        
        x1 = normalizedPoints1(i,1);
        y1 = normalizedPoints1(i,2);
        w1 = normalizedPoints1(i,3);
        X1 = [x1,y1,w1]';

        Ai = zeros(2,9);
        %first row:
        Ai(1,1:3) = [0,0,0];
        Ai(1,4:6) = -w2*(X1');
        Ai(1,7:9) = y2*(X1');
        %second row: 
        Ai(2,1:3) = w2*(X1');
        Ai(2,4:6) = [0,0,0];
        Ai(2,7:9) = -x2*(X1');
 
        A((i*2)-1:i*2,1:9) = Ai;        
    end    

    %stage: (5)
    [U,S,V] = svd(A, 0);
    [vRows, vCols] = size(V);
    hAsCol = V(:,vCols);

    %stage: (6)
    H = vec2mat(hAsCol,3);
    H = (inv(T2)*H*T1)';
end