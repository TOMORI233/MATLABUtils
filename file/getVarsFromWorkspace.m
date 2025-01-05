function res = getVarsFromWorkspace(varargin)
    % Description: Search variable in workspace using regexp.
    % Output: res.(Name) = Val;
    % Example:
    %     % To save all variables with names starting with "result_" or "output_"
    %     varNames = fieldnames(getVarsFromWorkspace("result_\W*", "output_\W*"));
    %     save("data.mat", varNames{:});

    if nargin < 1
        str = 'who;';
    else

        if ~any(cellfun(@(x) isempty(x) || isStringScalar(x) || (ischar(x) && isStringScalar(string(x))), varargin))
            error("getVarsFromWorkspace(): Invalid regexp input");
        end
    
        regexpstrs = cellfun(@(x) ['''', char(x), ''''], varargin, "UniformOutput", false);
        regexpstrs = join(regexpstrs, ',');
        regexpstrs = cat(1, regexpstrs{:});
    
        str = strcat('who("-regexp", ', regexpstrs, ');');
    end

    varNames = evalin("caller", str);

    if isempty(varNames)
        res = [];
        disp("No variables in workspace found.");
        return;
    end
    
    for index = 1:length(varNames)
        res.(varNames{index}) = evalin("caller", varNames{index});
    end

    return;
end