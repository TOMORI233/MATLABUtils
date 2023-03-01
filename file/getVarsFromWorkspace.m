function res = getVarsFromWorkspace(regexpStr)
    narginchk(0, 1);

    if nargin < 1
        str = 'who;';
    else
        str = strcat('who("-regexp", ''', regexpStr, ''');');
    end

    varNames = evalin("caller", str);
    
    for index = 1:length(varNames)
        res.(varNames{index}) = evalin("caller", varNames{index});
    end

    return;
end