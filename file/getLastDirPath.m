function [res, folderNames, path_Nth] = getLastDirPath(P, N)
    % [res] returns the last end-N+1:end folder path of path P
    % [folderNames] returns all folder names in [res] (from upper to lower)
    % [path_Nth] returns the last N-th folder name

    if N <= 0
        error("getLastDirPath(): input N should be positive integer");
    end

    [FILEPATH, ~, EXT] = fileparts(P);

    % In case of being shadowed by other toolboxes
    if ~strcmp(which('split'), fullfile(matlabroot, 'toolbox/matlab/strfun/split.m'))
        split = path2func(fullfile(matlabroot, 'toolbox/matlab/strfun/split.m'));
    else
        split = @split;
    end

    if isempty(EXT) % P is folder path

        if endsWith(P, '\')
            P = char(P);
            P = P(1:end - 1);
        end

        temp = split(P, '\');
    else % P is full path of a file
        temp = split(FILEPATH, '\');
    end
    
    res = fullfile(temp{end - N + 1:end});
    folderNames = temp(end - N + 1:end);
    path_Nth = temp{end - N + 1};
    return;
end