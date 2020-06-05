%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a sample script that calls the miCompute function to estimate the 
% MIF between two simulated random processes which are composed of random 
% sinusoids to reflect neural oscillations. This is inspired by prior work 
% (Malladi et al, 2018: https://doi.org/10.1109/TSP.2018.2821627).
%
% The equations are:
%   X(t) = A_x*cos(2*pi*f_0*t+theta_x)
%   W(t) = A_w*cos(2*pi*f_0*t+theta_w)
%   Y(t) = X(t)+W(t)
%
% with:
%   A_x ~ Rayleigh(B_x=1)
%   A_w ~ Rayleigh(B_w)
%   theta_x ~ uniform(0, 2*pi)
%   theta_w ~ uniform(0, 2*pi)
%
% Analytically, the true MI is:
%   MI_XY(f_0,f_0) = log(1+(((B_x^2)/2)/((B_w^2)/2)));
%
% This script will generate a variety of simulations of X, W, & Y, and
% compare the estimated and true MI_XY(f_0,f_0). Note that each simulation
% takes on a random true MI_XY(f_0,f_0) value, and therefore we expect a
% strong correlation between estimated and true MI_XY(f0,f0) values across
% these random values.
%
% Copyright (C) 2020 Joseph Young - see GPLv2_note.txt for full notice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
addpath helper_functions
load_mex_directory          % Adds mex directory based on OS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N      = 1e2;           % # trials (# sample paths) used for each MI estimate
I      = 1e3;           % Number of times to simulate and get MI estimate

T      = 1;             % Time length of trials in seconds
Fs     = 100;           % Sampling frequency in Hz
Fm     = 1;             % Maximum frequency to compute MI for in Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODEL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_0     = 0.9901;        % Frequency for x and w in Hz
B_x     = 1;             % Parameter for x sinusoid rayleigh amplitude (don't change)

MI_offset = 1;      % True MI values will range from (MI_offset-MI_bnd) to (MI_offset+MI_bnd)
MI_bnd    = 0.2;    % Note that B_w is how we change the true MI value in each simulation
B_w       = 1./sqrt(exp((MI_bnd*2*(rand([1,I])-0.5))+MI_offset)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATE & ESTIMATE MIF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time   = repmat((0:(1/Fs):T)',[1,N]);
L      = size(time,1);

% Initialize variable(s)
MI_est = zeros(I,1);
MI_tru = zeros(I,1);

% Loop through simulations for different true MIF / B_w values
for ii=1:I
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GENERATE x [shape: (time)X(trials)]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A_x     = repmat(raylrnd(B_x,[1,N]),[L,1]);
    theta_x = repmat(2*pi*rand([1,N]),[L,1]);
    x       = A_x.*cos(2*pi*f_0*time + theta_x);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GENERATE w [shape: (time)X(trials)]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A_w     = repmat(raylrnd(B_w(ii),[1,N]),[L,1]);
    theta_w = repmat(2*pi*rand([1,N]),[L,1]);
    w       = A_w.*cos(2*pi*f_0*time + theta_w);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GENERATE y = x + w [shape: (time)X(trials)]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y       = x+w;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ESTIMATE MUTUAL INFORMATION IN FREQUENCY BETWEEN x AND y VIA THE POST
    % MULTITAPER MIF ESTIMATOR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [MI,f]     = miCompute( x, y, Fs, Fm, N/2, 0 ); % Estimate MI_XY for all freq
    MI_est(ii) = MI(round(f,4)==round(f_0,4));         % Find MI_XY for f_0
    MI_tru(ii) = log(1+(((B_x^2)/2)/((B_w(ii)^2)/2)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
corr_mat     = corr([MI_est MI_tru]); % Correlation b/w est & tru values
est_tru_corr = corr_mat(2,1);       

scatter(MI_est, MI_tru)
title(...
    sprintf('Correlation Between Estimated & True MI_{XY}(f_0,f_0): %0.2f',...
    est_tru_corr), 'Interpreter','tex')
xlabel('Estimated MI_{XY}(f_0,f_0)', 'Interpreter','tex')
ylabel('True MI_{XY}(f_0,f_0)', 'Interpreter','tex')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
