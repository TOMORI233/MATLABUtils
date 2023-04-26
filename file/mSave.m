function mSave(FILENAME, varargin)
    % Check whether FILE exists and if it does, do nothing
    nVars = find(cellfun(@(x) contains(x, "-"), varargin), 1) - 1;

    if isempty(nVars)
        nVars = numel(varargin);
    end

    for index = 1:nVars
        res = evalin("caller", varargin{index});
        eval(strcat(varargin{index}, "=res;"));
    end

    if ~exist(FILENAME, "file")
        save(FILENAME, varargin{:});
    else
        disp(strcat(FILENAME, " already exists. Skip saving."));
    end

end