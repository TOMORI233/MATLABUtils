function [secs, key] = KbGet(validKeycode, limit)
    narginchk(0, 2);

    if nargin < 1
        validKeycode = 1:256;
    end

    if nargin < 2
        limit = inf;
    end

    [~, oldSecs, oldKeyCode, ~] = KbCheck;
    x = [];

    while isempty(x) || ~any(validKeycode == x)
        [secs, keyCode, ~] = KbWait([], 2, limit);
        x = find(keyCode > oldKeyCode);
        oldKeyCode = keyCode;
        
        if secs - oldSecs >= limit
            key = 0;
            return;
        end

    end

    key = x(1);
    return;
end