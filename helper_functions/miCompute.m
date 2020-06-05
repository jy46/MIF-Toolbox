function [ MI, f ] = miCompute( x, y, Fs, Fm, K, Np )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE MI BETWEEN X & Y
%
% INPUTS
%   x           - (mat) (time)X(trials) array
%   y           - (mat) (time)X(trials) array
%   Fs          - (int) Sampling frequency in Hz
%   Fm          - Maximum frequency to compute MIF for 
%   K           - (int) number of neighbors for knn MI estimate
%   Np          - number of permutations for significance testing
%
% OUTPUTS
%   MI          - MI in frequency
%   f           - frequencies used by MI
%
% Copyright (C) 2020 Joseph Young
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % TAPERED FFT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Xf,Yf,f] = miFPrep(x,y,Fs,Fm); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COMPUTE MI FOR EACH TAPER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii=1:size(Xf,3)            
        MI(ii,:,:) = miFreqMatStatLINEAR(squeeze(Xf(:,:,ii,:)),...
                                         squeeze(Yf(:,:,ii,:)),...
                                         K,Np); % Compute MI
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % AVERAGE ACROSS TAPERS & TAKE DIAGONAL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    MI = squeeze(mean(MI,1));        % Avg MI estimates across tapers
    MI = diag(MI);                   % Take diagonal (linear MIF)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
