function setTitle(FigOrAxes, setValue)


if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end

for aIndex = 1 : length(allAxes)
    allAxes(aIndex).Title.String = setValue(end - aIndex + 1);
end

end