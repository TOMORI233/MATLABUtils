function path = getAbsPath(relativePath)
    relativePath = char(relativePath);

    if contains(relativePath, '..') % relative path
        currentPath = pwd;
        evalin("caller", ['cd(''', relativePath, ''')']);
        path = pwd;
        cd(currentPath);
    else % absolute path
        path = relativePath;
    end

    return;
end