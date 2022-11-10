function value = getLine(FigOrAxes, getParams, searchParams, searchValue)



if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end


lineObj = findobj(FigOrAxes, "type", "line");
   if ~isnumeric(searchValue)
        tIndex = find(string({lineObj.(searchParams)}') == string(searchValue));
    else
        tIndex = find(cell2mat(cellfun(@(x) isequal(x, searchValue), {lineObj.(searchParams)}', "UniformOutput", false)));
    end

for cIndex = 1 : length(tIndex)
    value(cIndex).(getParams) = lineObj(tIndex(cIndex)).(getParams);
end

% for aIndex = 1:length(allAxes)
%     for lIndex = 1 : length(allAxes(aIndex).Children)
%         if contains(class(allAxes(aIndex).Children(lIndex)), 'line', 'IgnoreCase', true)
%             if isempty(searchParams)
%                 allAxes(aIndex).Children.(setParams) = setValue;
%             else
%                 if allAxes(aIndex).Children(lIndex).(searchParams) == searchValue
%                     allAxes(aIndex).Children(lIndex).(setParams) = setValue;
%                 end
%             end
%         end
%     end
% end

end