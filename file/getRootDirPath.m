function ROOTPATH = getRootDirPath(currentPath, N)
    % If N is set non-zero, return N-backward root path of current path.
    % NOTICE: DO NOT SET FieldTrip PATH to THE TOP
    % e.g.
    % currentPath = fileparts(mfilename("fullpath"))
    % >> currentPaht = 'D:\Education\Lab\MATLAB Utils\file'
    %
    % ROOTPATH = getRootDirPath(currentPath, 1)
    % >> ROOTPATH = 'D:\Education\Lab\MATLAB Utils\'

    if N <= 0
        error('N should be positive.');
    end

    temp = split(char(currentPath), '\')';

    if length(temp) <= N
        error('Could not backward any more.');
    end

    ROOTPATH = [fullfile(temp{1:end - N}), '\'];
    
    return;
end