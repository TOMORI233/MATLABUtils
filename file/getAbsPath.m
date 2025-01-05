function P = getAbsPath(relativePath)
    % Description: get absolute path from relative path
    % NOTICE: If relative path does not exist, the folder will be created.

    relativePath = char(relativePath);

    if isempty(char(relativePath)) 
        P = evalin("caller", "fileparts(mfilename('fullpath'))");
        return;
    end

    if contains(relativePath, '..') % relative path
        currentPath = pwd;
        if ~exist(relativePath, "dir")
            disp(strcat(relativePath, ' does not exist. Create folder...'));
            mkdir(relativePath);
        end
        evalin("caller", ['cd(''', relativePath, ''')']);
        P = pwd;
        cd(currentPath);
    else % absolute path
        P = relativePath;
    end

    return;
end