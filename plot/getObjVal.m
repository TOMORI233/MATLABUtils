function [value, tarObj] = getObjVal(FigsOrAxes, ObjType, getParams, varargin)

    mIp = inputParser;
    mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
    mIp.addRequired("ObjType", @(x) any(validatestring(x, {'line', 'image', 'axes'})));
    mIp.addRequired("getParams");
    mIp.addOptional("searchParams", [], @(x) isstring(x));
    mIp.addOptional("searchValue", [], @(x) any(isnumeric(x)|isstring(x)));
    mIp.parse(FigsOrAxes, ObjType, getParams, varargin{:});

    searchParams = mIp.Results.searchParams;
    searchValue = mIp.Results.searchValue;

if strcmp(class(FigsOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigsOrAxes, "Type", "axes");
else
    allAxes = FigsOrAxes;
end


Obj = findobj(FigsOrAxes, "type", ObjType);
if isempty(Obj)
    value = [];
    tarObj = [];
    return
end

if isempty(searchParams)
    tIndex = numel(Obj);
else
    for sIndex = 1 : length(searchValue)
        if ~isnumeric(searchValue(sIndex))
            tIndex(:, sIndex) = strcmpi({Obj.(searchParams(sIndex))}', searchValue(sIndex));
        else
            tIndex(:, sIndex) = cell2mat(cellfun(@(x) isequal(x, searchValue(sIndex)), {Obj.(searchParams(sIndex))}', "UniformOutput", false));
        end
    end
    tIndex = find(all(tIndex, 2));
end


if isempty(tIndex)
    value = [];
    tarObj = [];
    return
end

tarObj = Obj(tIndex);
if isempty(getParams)
    value = [];
end
for pIndex = 1 : length(getParams)
    for cIndex = 1 : length(tIndex)
        value(cIndex).(getParams(pIndex)) = Obj(tIndex(cIndex)).(getParams(pIndex));
    end
end
end