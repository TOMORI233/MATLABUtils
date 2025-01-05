function varargout = getObjVal(FigsOrAxes, ObjType, varargin)

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
mIp.addRequired("ObjType", @(x) any(validatestring(x, {'line', 'patch', 'bar', 'image', 'axes', 'figure', 'FigOrAxes', 'Histogram'})));
mIp.addOptional("getParams", [], @(x) any(isempty(x) | all(isstring(x))));
mIp.addOptional("searchParams", [], @(x) isstring(x));
mIp.addOptional("searchValue", [], @(x) any(isnumeric(x)|isstring(x)));
mIp.parse(FigsOrAxes, ObjType, varargin{:});

getParams = mIp.Results.getParams;
searchParams = mIp.Results.searchParams;
searchValue = mIp.Results.searchValue;

if ~isequal(ObjType, "FigOrAxes")
    Obj = findobj(FigsOrAxes, "type", ObjType);
else
    temp = cellfun(@(x) reshape(findobj(FigsOrAxes, "type", x), [], 1), ["figure", "axes"], "UniformOutput", false);
    temp(cellfun(@isempty, temp)) = [];
    Obj = [];
    for idx = 1:length(temp)
        Obj = [Obj; temp{idx}];
    end
end
if isempty(Obj)
    disp("no satisfactory objects finded!")
    varargout{1} = [];
    varargout{2} = [];
    return
end

if isempty(searchParams)
    tIndex = 1:numel(Obj);
else
    for sIndex = 1 : length(searchValue)
        if ~isnumeric(searchValue(sIndex))
            tIndex(:, sIndex) = strcmpi(get(Obj, searchParams), searchValue(sIndex));
        else
            tIndex(:, sIndex) = cell2mat(cellfun(@(x) isequal(x, searchValue(sIndex)), get(Obj, searchParams), "UniformOutput", false));
        end
    end
    tIndex = find(all(tIndex, 2));
end


if isempty(tIndex)
    %     disp("no satisfactory objects finded!")
    varargout{1} = [];
    varargout{2} = [];
    return
end

tarObj = Obj(tIndex);
if isempty(getParams)
    varargout{1} = tarObj;
    return
end
for pIndex = 1 : length(getParams)
    for cIndex = 1 : length(tarObj)
        varargout{1}(cIndex).(getParams(pIndex)) = get(tarObj(cIndex), getParams(pIndex));
    end
end
varargout{2} = tarObj;
return
end