function checkPyVersion()
paths = getenv("Path");
pyPaths = split(paths, ";");
pyPaths = pyPaths(contains(pyPaths, "Python", "IgnoreCase", true));
pyPaths = pyPaths(logical(cellfun(@(x) exist(fullfile(x, "python.exe"), "file"), pyPaths)));

% delete '\' at the end of the path
for index = 1:length(pyPaths)
    if endsWith(pyPaths{index}, '\')
        pyPaths{index} = pyPaths{index}(1:end - 1);
    end
end

% find python versions (3.x)
[mainvers, subvers] = deal(zeros(length(pyPaths), 1));
for index = 1:length(pyPaths)
    str = strcat(fullfile(pyPaths{index}, "python.exe"), " --version");
    [~, ver] = system(str);
    ver = strrep(ver, 'Python ', '');
    ver = split(ver, '.');
    mainvers(index) = str2double(ver{1});
    subvers(index) = str2double(ver{2});
end

if mainvers(1) < 3 || (mainvers(1) == 3 && subvers(1) > 7)
    warning(['Unsupported python version for kilosort 3 ' ...
             '(current python version is ', ...
             num2str(mainvers(1)), '.', num2str(subvers(1)), '.x).']);

    if any(mainvers == 3 & subvers == 7)
        warning('Use python 3.7 instead.');
        for index = 1:length(pyPaths)
            paths = strrep(paths, [pyPaths{index}, '\;'], '');
            paths = strrep(paths, [pyPaths{index}, ';'], '');
            paths = strrep(paths, [pyPaths{index}, '\Scripts\;'], '');
            paths = strrep(paths, [pyPaths{index}, '\Scripts;'], '');
        end
        paths = [pyPaths{find(mainvers == 3 & subvers == 7, 1)}, ';', ...
                 pyPaths{find(mainvers == 3 & subvers == 7, 1)}, '\Scripts;', ...
                 paths];
        setenv("Path", paths);
    else
        error('No compatible python version found.');
    end

end