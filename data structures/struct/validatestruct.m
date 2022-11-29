function [pass, msg] = validatestruct(s, varargin)
    % Description: validate each field of a struct vector
    % Input:
    %     s: a struct vector
    %     fieldname: field name of [s] to validate
    %     validatefcn: validate function handle
    % Output:
    %     pass: pass validation or not
    %     msg: validation failure message

    fIdx = find(cellfun(@(x) ischar(x) || isstring(x), varargin));
    msg = 'Validation Failed: ';
    pass = true;

    for sIndex = 1:length(s)

        for n = 1:length(fIdx)

            try
                varargin{fIdx(n) + 1}(s(sIndex).(varargin{fIdx(n)}));
            catch e
                msg = [msg, newline, num2str(sIndex), ' - ', char(varargin{fIdx(n)}), ': ', char(e.message)];
                pass = false;
            end

        end

    end

    if ~pass
        disp(msg);
    else
        msg = 'Validation passed';
    end

    return;
end
