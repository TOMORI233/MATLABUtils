function setLine(FigOrAxes, setParams, setValue, searchParams, searchValue)

narginchk(3, 5);

if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end

if nargin < 4
    searchParams = [];
end

if nargin == 4
    error('the number of input should be 2, 3, or 5!');
end

lineObj = findobj(FigOrAxes, "type", "line");
   if ~isnumeric(searchValue)
        tIndex = find(string({lineObj.(searchParams)}') == string(searchValue));
    else
        tIndex = find(cell2mat(cellfun(@(x) isequal(x, searchValue), {lineObj.(searchParams)}', "UniformOutput", false)));
    end

for cIndex = 1 : length(tIndex)
    lineObj(tIndex(cIndex)).(setParams) = setValue;
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