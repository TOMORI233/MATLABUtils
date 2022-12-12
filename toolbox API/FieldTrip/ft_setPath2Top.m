function ft_setPath2Top

try
    % find existing FieldTrip paths
    startupPath = which("startup", "-all");
    mPath = string(regexp(startupPath{end}, '.*FieldTrip', 'match'));
    temp = dir(strcat(mPath, "\**\*"));
    mfolders = string({temp([temp.isdir]').folder}');
    p = string(strsplit(path, ";"))';
    toRm = cellstr(intersect(mfolders, p));
    
    % clear existing FieldTrip paths and re-add at the bottom
    rmpath(toRm{:});
    addpath(toRm{:}, "-begin");
catch e
    disp(e.message);
end