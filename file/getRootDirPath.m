function ROOTPATH = getRootDirPath(currentPath, N)
    % If N is set non-zero, return N-backward root path of current path.
    % e.g.
    % currentPath = fileparts(mfilename("fullpath"))
    % >> currentPaht = 'D:\Education\Lab\MATLAB Utils\file'
    %
    % ROOTPATH = getRootDirPath(currentPath, 1)
    % >> ROOTPATH = 'D:\Education\Lab\MATLAB Utils\'

    if N <= 0
        error('N should be positive.');
    end

    temp = split(currentPath, '\');

    if length(temp) <= N
        error('Could not backward any more.');
    end

    temp = join(temp(1:end - N), '\');
    ROOTPATH = [temp{1}, '\'];
    
    return;
end