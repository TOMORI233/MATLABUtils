function mPrint(target, FILENAME, formattype, resolution)
    % Check whether FILE exists and if it does, do nothing
    narginchk(2, 4);

    if nargin < 3
        formattype = "-djpeg";
    end

    if nargin < 4
        resolution = "-r300";
    end

    % Using absolute path for current path
    if ~contains(FILENAME, '\')
        FILENAME = strcat(pwd, "\", FILENAME);
    end

    if ~exist(FILENAME, "file")
        print(target, FILENAME, formattype, resolution);
    else
        disp("File already exists. Skip printing.");
    end

end