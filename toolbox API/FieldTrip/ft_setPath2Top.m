function ft_setPath2Top

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
    
    % clear existing FieldTrip paths and re-add at the bottom
    rmpath(toRm{:});
    addpath(toRm{:}, "-begin");
catch e
    disp(e.message);
end