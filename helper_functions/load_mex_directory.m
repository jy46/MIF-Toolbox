%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to load directories for MIF
% The folder for mex files is loaded based on which OS is being used
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ismac
    addpath tstool_files/mex_mac/
elseif isunix
    addpath tstool_files/mex_linux/
elseif ispc
    addpath tstool_files/mex_win/
else
    disp('Platform not supported')
end
