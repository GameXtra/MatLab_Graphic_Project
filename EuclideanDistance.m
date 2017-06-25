function [D] = euclideanDistance(G,G2)
    V = G - G2;
    D = sqrt(V * V');
end