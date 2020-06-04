function [IXY_val] = miKnnTS_return_IXY(Xf_sel,Yf_sel,K)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETURNS MI BETWEEN X & Y AT A PARTICULAR FREQUENCY.
%
% INPUTS
%   Xf_sel - FFT of x at 1 frequency, should be in shape (Ns)x(2). Ns
%               refers to the number of samples, (coming from the FFT of Ns
%               trials/windows), while 2 refers to the real and imaginary
%               dimensions of the complex value.
%   Yf_sel - FFT of y at 1 frequency, should be in shape (Ns)x(2)
%   K      - number of neighbors to use in KNN
%
% OUTPUTS
%   IXY_val - MI between X & Y at frequency that Xf_sel/Yf_sel are for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute MI
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    currI    = miKnnTS(Xf_sel,Yf_sel,K); % Struct that contains MI
    IXY_val  = currI.IXY;                % Extract MI from struct
    
end

