function ROOTPATH = getRootDirPath(P, N)
    % If [N] is set non-zero, return N-backward root path of path [P].
    % 
    % e.g.
    %     currentPath = fileparts(mfilename("fullpath"))
    %     >> currentPath = 'D:\Education\Lab\MATLAB Utils\file'
    %
    %     ROOTPATH = getRootDirPath(currentPath, 1)
    %     >> ROOTPATH = 'D:\Education\Lab\MATLAB Utils\'

    if N <= 0
        error('getRootDirPath(): N should be positive.');
    end

    split = path2func(fullfile(matlabroot, 'toolbox/matlab/strfun/split.m'));
    temp = split(char(P), '\')';

    if length(temp) <= N
        error('getRootDirPath(): Could not backward any more.');
    end

    ROOTPATH = [fullfile(temp{1:end - N}), '\'];
    
    return;
end