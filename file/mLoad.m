function mLoad(fileName, varNames)
    % Load *.mat to workspace and if varNames exist in workspace, do nothing
    narginchk(1, 2)

    temp = whos("-file", fileName);
    temp = string(parseStruct(temp, "name"));

    if nargin > 1

        switch class(varNames)
            case "cell"
                
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

    varNames0 = evalin("caller", "fieldnames(getVarsFromWorkspace());");
    if all(cellfun(@(x) contains(x, varNames0), varNames))
        disp('Variables already exist in workspace. Skip loading.');
    else
        varNames = cellfun(@(x) strcat('"', x, '"'), varNames);
        evalin("caller", strcat("load(""", fileName, """, ", join(varNames, ", "), ");"));
    end

    return;
end