function orderLine(FigOrAxes, searchParams, searchValue, order)

narginchk(3, 4);

if nargin < 4
    order = "bottom";
end

if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end

for aIndex = 1:length(allAxes)

    lineObj = get(allAxes(aIndex),'Children');
    childField = fields(lineObj);
    if ~ismember(string(searchParams), string(childField))
        continue
    end
    if ~isnumeric(searchValue)
        tIndex = find(string({lineObj.(searchParams)}') == string(searchValue));
    else
        tIndex = find(cell2mat(cellfun(@(x) isequal(x, searchValue), {lineObj.(searchParams)}', "UniformOutput", false)));
    end
    temp = 1 : length(lineObj);
    temp(tIndex) = [];
    if string(order) == "bottom"
        reOrder = [temp, tIndex];
    elseif string(order) == "top"
        reOrder = [tIndex, temp];
    else
        error("error order input!");
    end
    reOrdObj = lineObj(reOrder);
    set(allAxes(aIndex), 'Children', reOrdObj);
end

end
