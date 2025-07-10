function P = getAbsPath(relativePath)
    % Description: get absolute path from relative path
    % NOTICE: If relative path does not exist, the folder will be created.

    relativePath = char(relativePath);

    if isempty(char(relativePath))
        currentPath = pwd;
        evalin("caller", ['cd(''', pwd, ''')']);
        P = pwd;
        cd(currentPath);
        return;
    end

    if contains(relativePath, '..') || ~contains(relativePath, ':') % relative path
        currentPath = pwd;

        if ~contains(relativePath, '\') && ~contains(relativePath, '/')
            % Input is a single file name
            P = fullfile(pwd, relativePath);
            return;
        end

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