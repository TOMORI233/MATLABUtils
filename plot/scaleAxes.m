function axisRange = scaleAxes(FigsOrAxes, axisName, axisRange, cutoffRange, symOpts)
    % Description: apply the same scale settings to all subplots in figures
    % Input: 
    %     FigsOrAxes: figure object array or axis object array
    %     axisName: axis name - "x", "y", "z" or "c"
    %     axisRange: axis limits, specified as a two-element vector. If
    %                given value -Inf or Inf, or left empty, the best range
    %                will be used.
    %     cutoffRange: if axisRange exceeds cutoffRange, axisRange will be
    %                  replaced by cutoffRange.
    %     symOpts: symmetrical option - "min" or "max"
    % Output:
    %     axisRange: axis limits applied

    narginchk(1, 5);

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

    if strcmp(class(FigsOrAxes), "matlab.ui.Figure")|| strcmp(class(FigsOrAxes), "matlab.graphics.Graphics")
        allAxes = findobj(FigsOrAxes, "Type", "axes");
    else
        allAxes = FigsOrAxes;
    end

    if nargin < 3
        axisRange = [];
    end

    %% Best axis range
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

    bestRange = [axisLimMin, axisLimMax];

    if isempty(axisRange)
        axisRange = bestRange;
    else

        if axisRange(1) == -inf
            axisRange(1) = bestRange(1);
        end
    
        if axisRange(2) == inf
            axisRange(2) = bestRange(2);
        end

    end

    %% Cutoff axis range
    if nargin < 4 || isempty(cutoffRange)
        cutoffRange = [-inf, inf];
    end

    if axisRange(1) < cutoffRange(1)
        axisRange(1) = cutoffRange(1);
    end

    if axisRange(2) > cutoffRange(2)
        axisRange(2) = cutoffRange(2);
    end

    %% Symmetrical axis range
    if nargin >= 5

        switch symOpts
            case "min"
                temp = min(abs(axisRange));
            case "max"
                temp = max(abs(axisRange));
            otherwise
                error("Invalid symmetrical option input");
        end

        axisRange = [-temp, temp];
    end

    %% Set axis range
    for aIndex = 1:length(allAxes)
        set(allAxes(aIndex), axisLimStr, axisRange);
    end
    
    return;
end