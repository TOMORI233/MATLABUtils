function [res, folderNames] = getLastDirPath(P, N)
    % [res] return the last end-N+1:end folder path of path P
    % [folderNames] return all folder names in [res] (from upper to lower)

    if N <= 0
        error("getLastDirPath(): input N should be positive integer");
    end

    [FILEPATH, ~, EXT] = fileparts(P);
    split = path2func(fullfile(matlabroot, 'toolbox/matlab/strfun/split.m'));

    if isempty(EXT) % P is folder path
        temp = split(P, '\');
    else % P is full path of a file
        temp = split(FILEPATH, '\');
    end
    
    res = fullfile(temp{end - N + 1:end});
    folderNames = temp(end - N + 1:end);
    return;
end