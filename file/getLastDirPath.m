function res = getLastDirPath(fullPath, N)
    res = fileparts(fullPath); % get folder
    temp = split(res, '\');
    res = fullfile(temp{end - N + 1:end});
end