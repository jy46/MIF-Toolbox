function [ T ] = miKnnTS(x,y,K)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORMS MUTUAL INFORMATION ESTIMATION USING KNN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   x - input x data with dim (NxD) [N=number of samples, D=number of dim]
%   y - input y data with dim (NxD)
%   K - number of neighbors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   T   - output object to contain all other outputs
%   HXY - estimated joint entropy of x and y using Knn
%   HX  - estimated entropy of x using Knn
%   HY  - estimated entropy of y using Knn
%   IXY - estimated mutual information between x and y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOURCES
%   - Kraskov, Stogbauer, & Grassberger. Estimating mutual information.
%     Physical Review E 69. (2004)
%   - Sudha Yellapantula - Rice University
%
% Copyright (C) 2020 Joseph Young - see GPLv2_note.txt for full notice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COMPUTE H(X,Y), H(X), H(Y) & I(X,Y)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [T.HXY,d]   = jointEntropyKnn(x,y,K);
    T.HX        = entropyKnn(x,d);
    T.HY        = entropyKnn(y,d);
    T.IXY       = T.HX+T.HY-T.HXY;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
