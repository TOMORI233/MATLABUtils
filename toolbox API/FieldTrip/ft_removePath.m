function ft_removePath

try
    % find existing FieldTrip paths
    pathsAll = path;
    pathsAll = split(pathsAll, ';');
    toRm = pathsAll(contains(pathsAll, 'fieldtrip', 'IgnoreCase', true));
    
    % startupPath = which("startup", "-all");
    % mPath = regexp(startupPath, '.*FieldTrip', 'match');
    % mPath = string(mPath{~cellfun(@isempty, mPath)});
    % temp = dir(strcat(mPath, "\**\*"));
    % mfolders = string({temp([temp.isdir]').folder}');
    % p = string(strsplit(path, ";"))';
    % toRm = cellstr(intersect(mfolders, p));
    
    % clear existing FieldTrip paths
    rmpath(toRm{:});

    % add path of current file and the root path of fieldtrip
    
catch e
    disp(e.message);
end