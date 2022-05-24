function axisRange = scaleAxes(FigsOrAxes, axisName, axisRange)
    % Description: apply the same scale settings to all subplots in figures
    % Input: 
    %     FigsOrAxes: figure object or target axes object array
    %     axisName: axis name - "x", "y" or "z"
    %     axisRange: axis lim
    % Output:
    %     axisRange: axis lim

    narginchk(1, 3);

    if nargin < 2
        axisName = "y";
    end
    
    if strcmpi(axisName, "x")
        axisLimStr = "xlim";
    elseif strcmpi(axisName, "y")
        axisLimStr = "ylim";
    elseif strcmpi(axisName, "z")
        axisLimStr = "zlim";
    elseif strcmpi(axisName, "c")
        axisLimStr = "clim";
    else
        error("Wrong axis name input");
    end

    if strcmp(class(FigsOrAxes), "matlab.ui.Figure")
        allAxes = findobj(FigsOrAxes, "Type", "axes");
    else
        allAxes = FigsOrAxes;
    end

    if nargin < 3
        axisLim = get(allAxes(1), axisLimStr);
        axisLimMin = axisLim(1);
        axisLimMax = axisLim(2);

        for aIndex = 2:length(allAxes)
            axisLim = get(allAxes(aIndex), axisLimStr);
            
            if axisLim(1) < axisLimMin
                axisLimMin = axisLim(1);
            end

            if axisLim(2) > axisLimMax
                axisLimMax = axisLim(2);
            end

        end
    
        axisRange = [axisLimMin, axisLimMax];
    end

    for aIndex = 1:length(allAxes)
        set(allAxes(aIndex), axisLimStr, axisRange);
    end
    
    return;
end