function path = getAbsPath(relativePath)
    relativePath = char(relativePath);

    if contains(relativePath, '..') % relative path
        currentPath = pwd;
        if ~exist(relativePath, "dir")
            disp(strcat(relativePath, ' does not exist. Create folder...'));
            mkdir(relativePath);
        end
        evalin("caller", ['cd(''', relativePath, ''')']);
        path = pwd;
        cd(currentPath);
    else % absolute path
        disp("Your input is already absolute path");
        path = relativePath;
    end

    return;
end