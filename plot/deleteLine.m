function FigOrAxes = deleteLine(FigOrAxes, searchParams, searchValue)

if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end

lineObj = findobj(FigOrAxes, "type", "line");
delete(lineObj((string({lineObj.(searchParams)}') == searchValue)));

end