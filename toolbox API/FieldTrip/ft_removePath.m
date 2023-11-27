function ft_removePath
% remove FieldTrip paths but reserve root path of ft_defaults
% run ft_defaults to restore FieldTrip paths

try
    % find existing FieldTrip paths
    pathsAll = path;
    pathsAll = split(pathsAll, ';');
    toRm = pathsAll(contains(pathsAll, 'fieldtrip', 'IgnoreCase', true));
    ftRootPath = fileparts(which("ft_defaults"));
    
    ftRootPath = fileparts(which("ft_defaults"));
    
    % clear existing FieldTrip paths
    rmpath(toRm{:});

    % add path of current file and the root path of ft_defaults
    addpath(fileparts(mfilename("fullpath")));
    addpath(ftRootPath);
catch e
    disp(e.message);
end