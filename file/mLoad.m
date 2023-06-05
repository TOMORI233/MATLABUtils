function mLoad(fileName, varNames)
    % Load *.mat to workspace and if [varNames] exist in workspace, do nothing.
    % If a part of [varNames] are in workspace, the rest part will be loaded.
    % [varNames] should be specified as cell vector, string vector or char.
    % If [fileName] is dir path or empty, use uigetfile to select a mat file.
    %
    % Example:
    %     mLoad([], ["var1", "var2"]);
    %     mLoad([], {"var1", "var2"});
    %     mLoad("C:\desktop", 'var1');

    narginchk(0, 2);

    if nargin < 1 || isempty(fileName)
        [fileName, path] = uigetfile("*.mat");
    elseif ~strcmpi(obtainArgoutN(@fileparts, 3, fileName), "mat")
        [fileName, path] = uigetfile(fullfile(fileName, "*.mat"));
    end

    fileName = fullfile(path, fileName);
    temp = whos("-file", fileName);
    temp = string(parseStruct(temp, "name"));

    if nargin > 1

        switch class(varNames)
            case "cell"
                if ~all(cellfun(@(x) any(strcmp(class(x), ["string", "char"])), varNames))
                    error("Invalid varNames input");
                end
                varNames = cellfun(@(x) string(x), varNames, "UniformOutput", false);
                varNames = reshape(varNames, [numel(varNames), 1]);
            case "string"
                varNames = num2cell(reshape(varNames, [numel(varNames), 1]), 2);
            case "char"
                varNames = string(varNames);
                varNames = num2cell(reshape(varNames, [numel(varNames), 1]), 2);
            otherwise
                error("Invalid input");
        end

    else
        varNames = num2cell(temp, 2);
    end

    vars = evalin("caller", "getVarsFromWorkspace();");
    if ~isempty(vars)
        varNames0 = fieldnames(vars);
        idx = ~cellfun(@(x) contains(x, varNames0), varNames);
    else
        idx = true(length(varNames), 1);
    end

    if all(~idx)
        disp('All specified variables already exist in workspace. Skip loading.');
    else
        varNames = cellfun(@(x) strcat('"', x, '"'), varNames(idx));
        evalin("caller", strcat("load(""", fileName, """, ", join(varNames, ", "), ");"));
    end

    return;
end