function makemex()

% compile and copy mex-files to destination directories
% Invoked by : makemex
% Edited by Joseph Young on June 4th, 2020 to only produce mex files for
% k-nn, and to put them in right folder for your OS

if ismac
    TSTOOLpath = 'mex_mac';
elseif isunix
    TSTOOLpath = 'mex_linux';
elseif ispc
    TSTOOLpath = 'mex_win';
else
    disp('Platform not supported')
end

olddir = pwd;

if exist('mexext')==5
    suffix = ['.' mexext];
    system = computer;
elseif isunix
    [dummy, system] = unix('/bin/uname');
    switch system(1:end-1)
      case 'IRIX64'
        suffix = '.mexsg64';
      case 'IRIX'
        suffix = '.mexsg';
      case 'SunOS'
        suffix = '.mexsol';
      otherwise
        error('Unknown system type.');
    end
elseif ispc
    system = 'PCWIN';
    suffix = '.dll';
elseif ismac
    system = 'MACI'
    suffix = '.mexosx';
end

destpath = fullfile(TSTOOLpath);

clear functions;		% prevent locked files

disp('Building mex files for TSTOOL')
disp('')
disp(['System : ' system])
disp(['Suffix : ' suffix])
disp(['Destination : ' destpath])
disp('')
disp('')

try

	cd NN

	files = {'nn_prepare','nn_search','range_search'};	

	make(files, suffix, ' -O -I. -I.. -DPARTIAL_SEARCH ', destpath);

	cd(olddir)

catch
	warning(lasterr)
	cd(olddir)
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function flag = newer(filename1, filename2)

% flag = newer(filename, reffile)
% returns true if first file is newer than second file

try
	d = dir(filename1);
	d2 = dir(filename2);

	if isempty(d2)
		flag = 1;
		return
	end
	if isempty(d)
		flag = 0;
		warning(['Source file ' filename1 ' does not exist']);
		return
	end

	% datenum(d.date)
	% datenum(d2.date)

	if (datenum(d.date) > datenum(d2.date))
    	flag = 1;
	else
    	flag = 0;
	end
catch
	flag = 1;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function make(filenames, suffix, mexoptions, destpath)

% make(filenames, suffix, mexoptions, destpath)
%
% filenames is a cell array of filenames

for i=1:length(filenames)
	filename = filenames{i};
	destfile = fullfile('..',destpath, [filename suffix]);

	if newer([filename '.cpp'], [filename suffix])
		disp(['Making ' filename])

		try
			eval(['mex ' filename '.cpp ' mexoptions ]);
		catch
			warning(lasterr)
		end
	else
		disp([filename ' is up to date'])
	end

	if newer([filename suffix], destfile)
		disp(['Moving ' filename])
		try
			movefile([filename suffix], destfile);
		catch
			warning(lasterr)
		end
	end
end

