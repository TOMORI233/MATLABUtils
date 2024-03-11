function fcn = path2func(P)
    currentPath = pwd;

    % In case that P=which("fcn") is used
    if startsWith(P, 'built-in (') % for built-in function
        P = [P(11:end - 1), '.m'];
    end
    
    [FILEPATH, NAME, EXT] = fileparts(P);

    if strcmp(EXT, '.m')
        
        if strcmp(FILEPATH, '') % current path
            fcn = str2func(NAME);
        else
            cd(FILEPATH);
            fcn = str2func(NAME);
            cd(currentPath);
        end

    else
        error("path2func(): Input should be full path of *.m");
    end
    
    return;
end