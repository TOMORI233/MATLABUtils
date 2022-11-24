function axisValue = setAxes(FigOrAxes, axisParams, axisValue)
    % Description: apply the same scale settings to all subplots in one figure
    % Input: 
    %     FigOrAxes: figure object or target axes object array
    %     axisParams:  name - "color", "child" ...
    %     axisRange: axis lim
    % Output:
    %     axisRange: axis lim

    narginchk(2, 3);

    if strcmp(class(FigOrAxes), "matlab.ui.Figure") || strcmp(class(FigOrAxes), "matlab.graphics.Graphics")
        allAxes = findobj(FigOrAxes, "Type", "axes");
    else
        allAxes = FigOrAxes;
    end

    if nargin < 3
        axisValue = get(allAxes(1), axisParams);
    end
    
    for aIndex = 1:length(allAxes)
        set(allAxes(aIndex), axisParams, axisValue);
    end
    
    return;
end