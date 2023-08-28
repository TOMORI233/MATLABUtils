function [pass, msg] = validatestruct(s, varargin)
    % Description: validate each field of a struct vector
    % Input:
    %     s: a struct vector
    %     fieldname: field name of [s] to validate
    %     validatefcn: validate function handle
    % Output:
    %     pass: pass validation or not
    %     msg: validation failure message
    %          It shows in "sIndex - fieldName: error msg"

    fIdx = find(cellfun(@(x) ischar(x) || isstring(x), varargin));
    msg = 'Validation Failed : ';
    pass = true;

    for sIndex = 1:length(s)

        for n = 1:length(fIdx)

            try
                clearvars ans
                varargin{fIdx(n) + 1}(s(sIndex).(varargin{fIdx(n)}));

                if exist("ans", "var") && ~ans
                    msg = [msg, newline, num2str(sIndex), ' - ', char(varargin{fIdx(n)})];
                    pass = false;
                end
                
            catch ME
                msg = [msg, newline, num2str(sIndex), ' - ', char(varargin{fIdx(n)}), ': ', char(ME.message)];
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
