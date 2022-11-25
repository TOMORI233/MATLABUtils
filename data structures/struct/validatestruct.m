function pass = validatestruct(s, varargin)
    % Description: validate each field of a struct

    fIdx = find(cellfun(@(x) ischar(x) || isstring(x), varargin));
    msg = 'Validation Failed: ';
    pass = true;

    for n = 1:length(fIdx)

        try
            varargin{fIdx(n) + 1}(s.(varargin{fIdx(n)}));
        catch e
            msg = [msg, newline, char(varargin{fIdx(n)}), ': ', char(e.message)];
            pass = false;
        end

    end

    if ~pass
        disp(msg);
    end
    
    return;
end