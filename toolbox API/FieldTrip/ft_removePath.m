function ft_removePath
% remove FieldTrip paths but reserve root path of ft_defaults
% run ft_defaults to restore FieldTrip paths

try
    % find existing FieldTrip paths
    pathsAll = path;
    pathsAll = split(pathsAll, ';');
    toRm = pathsAll(contains(pathsAll, 'fieldtrip', 'IgnoreCase', true));
    
    % clear existing FieldTrip paths
    rmpath(toRm{:});

    % add path of current file and the root path of ft_defaults
    addpath(fileparts(mfilename("fullpath")));
    addpath(fileparts(which("ft_defaults")));
catch e
    disp(e.message);
end