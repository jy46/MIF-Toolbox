function [ Xf, Yf, f ] = miFPrep( x,y,Fs,Fm )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prep time series for input into MI in frequency by computing FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   x   - input time series, in shape of (Time)X(Trials)
%   y   - input time series, in shape of (Time)X(Trials)
%   Fs  - sampling frequency
%   Fm  - maximum frequency to allow in analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   Xf  - output FFT, in shape of (Nf)X(Ns)X(2) - note that 2 is because
%         the 1st val in that dim is the real & the 2nd is the imag
%   Yf  - output FFT, in shape of (Nf)X(Ns)X(2)
%   f   - output actual frequency range
%
% Copyright (C) 2020 Joseph Young - see GPLv2_note.txt for full notice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INITIALIZE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Nx  = size(x,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % APPLY TAPERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    window_mat = dpss(Nx, 3, 5); % Generate tapers
    for taper = 1:size(window_mat,2) % Loop through tapers
        tape_mat = repmat(window_mat(:, taper), [1, size(x,2)]);
        x_tape(:, :, taper) = x.*tape_mat;
        y_tape(:, :, taper) = y.*tape_mat;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FFT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X   = fft(x_tape,[],1)/Nx; % FFT operates along columns, therefore windows of trials
    Y   = fft(y_tape,[],1)/Nx; % Here we normalize the FFT by the number of sample pts

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FREQUENCIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    f   = (Fs*(0:(Nx/2))/Nx);
    f   = f(f<=Fm); % Get rid of frequencies that we know have been filtered
    Nf  = length(f);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EXTRACT RELEVANT FREQUENCIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Xp  = X(1:Nf,:,:);      % (frequencies)x(trials)x(tapers)
    Yp  = Y(1:Nf,:,:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SEPARATE REAL & IMAGINARY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Xf(:,:,:,1)  = real(Xp);   % (frequencies)x(trials)x(tapers)x(R/I)
    Xf(:,:,:,2)  = imag(Xp);
    Yf(:,:,:,1)  = real(Yp);
    Yf(:,:,:,2)  = imag(Yp);           
     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
