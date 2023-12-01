function dec = mHex2Dec(hex, varargin)
mIp = inputParser;
mIp.addRequired("hex", @(x) iscell(x)|ischar(x)|isnumeric(x)|isstring(x));
mIp.addParameter("isColor", true);
mIp.parse(hex, varargin{:});

isColor = mIp.Results.isColor;

if isnumeric(hex)
    dec = hex;
    return
elseif isstring(hex) || ischar(hex)
    if isColor
        dec = cell2mat(cellfun(@(x) hex2dec(x), mReshapeStr(erase(string(hex), "#"), 2), "UniformOutput", false));
    else
        dec = hex2dec(erase(string(hex), "#"));
    end
elseif iscell(hex)
    if ischar(hex{1})
        if isColor
            dec = cell2mat(cellfun(@(x) hex2dec(x), mReshapeStr(erase(string(hex), "#"), 2), "UniformOutput", false));
        else
            dec = hex2dec(erase(string(hex), "#"));
        end
    elseif isnumeric(hex{1})
        dec = cell2mat(hex);
    end
end

end