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

    for aIndex = 1:length(allAxes)
            lineIdx = find(contains(class(allAxes(aIndex).children), 'line', 'IgnoreCase', true));
        for lIndex = lineIdx    
            if isempty(searchParams)
                allAxes(aIndex).children.(setParams) = setValue;
            else
                if allAxes(aIndex).children.(searchParams) == searchValue
                    allAxes(aIndex).children.(setParams) = setValue;
                end
            end
        end
    end

end