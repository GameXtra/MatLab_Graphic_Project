function [D] = EuclideanDistance(G,G2)
    V = G - G2;
    D = sqrt(V * V');
end