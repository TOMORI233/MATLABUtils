function addLines2Axes(FigsOrAxes, lines)
    % Description: add lines to all subplots in figures
    % Input: 
    %     FigsOrAxes: figure object array or axis object array
    %     lines: a struct array of [X], [Y], [color], [lineWidth]
    %            If [X] or [Y] is left empty, then x/y range of the 

    if strcmp(class(FigsOrAxes), "matlab.ui.Figure")
        allAxes = findobj(FigsOrAxes, "Type", "axes");
    else
        allAxes = FigsOrAxes;
    end

    xRange = scaleAxes(allAxes, "x");
    yRange = scaleAxes(allAxes, "y");

    %% Plot lines
    for lIndex = 1:length(lines)

        for aIndex = 1:length(allAxes)
            X = getOr(lines(lIndex), "X");
            Y = getOr(lines(lIndex), "Y");
            color = getOr(lines(lIndex), "color", "k");
            lineWidth = getOr(lines(lIndex), "lineWidth", 1);
            lineStyle = getOr(lines(lIndex), "lineStyle", "--");

            if numel(X) == 0
                X = xRange;
            elseif numel(X) == 1
                X = X * ones(1, 2);
            end

            if numel(Y) == 0
                Y = yRange;
            elseif numel(Y) == 1
                Y = Y * ones(1, 2);
            end

            h = plot(allAxes(aIndex), X, Y, "Color", color, "LineWidth", lineWidth, "LineStyle", lineStyle);
            set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
            hold on;
        end

    end
    
    return;
end