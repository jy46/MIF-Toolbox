function [ MI ] = miFreqMatStatLINEAR( Xf,Yf,K,Np )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORMS MUTUAL INFORMATION IN FREQUENCY ANALYSIS BETWEEN X & Y.
%
% INPUTS
%   Xf - FFT of x, should be in shape (Nf)X(Ns)x(2)
%         - Nf is the number of frequencies that the FFT was computed for
%         - Ns refers to the number of samples, (coming from the FFT of Ns
%           trials/windows)
%         - 2 refers to the real and imaginary dimensions of the complex 
%           value
%   Yf - FFT of y
%   K  - number of neighbors to use in KNN
%   Np - number of permutations for significance testing
%
% OUTPUTS
%   MI - MI between the X & Y for all frequencies
%
% NOTE
%   The implemented significance testing relying on using a threshold 
%   equal to the 95th percentile of the maximum distribution, composed of 
%   maximum MIF samples across frequency for each permutation, is
%   based on a prior work: 
%       Pantazis et al. A comparison of random field theory and permutation 
%       methods for the statistical analysis of MEG data. NeuroImage 25. 
%       (2005)
%   
%   Our work augments the MIF paper by Malladi et al:
%       Malladi et al. Mutual information in frequency and its application 
%       to measure cross-frequency coupling in epilepsy.IEEE Transactions 
%       on Signal Processing 66. (2018)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter(s)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fraction_threshold = 0.95; % Change this to control the FWER
    MI_fun = @(x,y,z) miKnnTS_return_IXY(x,y,z); % Specify MI method
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Loop over all frequencies & compute MI
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    MI = nan(size(Xf,1));              % Off-diagonal will remain nan
    MI(1,1) = 0;                       % Set DC MI to zero
    for f1 = 2:size(Xf,1)
        for f2 = 2:size(Xf,1)
            if(f1==f2)                 % Only compute diagonal
                Xf_sel      = squeeze(Xf(f1,:,:)); % Xf_sel shape: (Ns)X(2)
                Yf_sel      = squeeze(Yf(f2,:,:));
                MI(f1,f2)   = MI_fun(Xf_sel,Yf_sel,K);
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Significance testing
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Np~=0
        MI_perm = nan(Np,size(Xf,1),size(Xf,1));
		for ii = 1:Np

			% First permute trials (2nd dim of Xf)
			newInd      = randperm(size(Xf,2)); 
			Xf_perm     = Xf(:,newInd,:);

			% Compute MI for permuted Xf across all frequencies
			for f1 = 2:size(Xf,1)
				for f2 = 2:size(Xf,1)
					if(f1==f2) % Only compute diagonal
						Xf_sel            = squeeze(Xf_perm(f1,:,:)); % Xf_sel shape: (Ns)X(2)
						Yf_sel            = squeeze(Yf(f2,:,:));
						MI_perm(ii,f1,f2) = MI_fun(Xf_sel,Yf_sel,K);
					end
				end
			end

		end

		% Retrieve maximum MIs
		MI_perm_max  = sort(squeeze(max(MI_perm,[],[2 3]))); % Vec of max MIs from perms
		MI_threshold = MI_perm_max(round(fraction_threshold*Np)); % Find 95th percentile val

		% Zero out MI values less than or equal to the 95th percentile shuffled val
		MI(MI<=MI_threshold) = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get rid of negative MI values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    MI(MI<0) = 0;

end
