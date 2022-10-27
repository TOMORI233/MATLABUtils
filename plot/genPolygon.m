function [xv, yv, lines] = genPolygon(mAxe)
    % Description: draw a polygon in the axes. Return its endpoint
    %              coordinates and borderlines. It only works with 2-D
    %              axes.


    xv = [];
    yv = [];
    lines = [];
    hold(mAxe, "on");
    
    while 1
        [x, y, btn] = ginput(1);
    
        if ~isempty(btn)
    
            if btn == 1
    
                if ~isempty(xv)
                    ltemp = plot(mAxe, [xv(end), x], [yv(end), y], "k.-", "LineWidth", 1);
                else
                    ltemp = plot(mAxe, x, y, "k.-", "LineWidth", 1);
                end
    
                xv = [xv, x];
                yv = [yv, y];
                lines = [lines, ltemp];
                set(get(get(ltemp, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
            elseif btn == 'z'

                if ~isempty(lines)
                    delete(lines(end));
                    lines = lines(1:end - 1);
                    xv = xv(1:end - 1);
                    yv = yv(1:end - 1);
                end

            end
    
        else
            ltemp = plot(mAxe, [xv(end), xv(1)], [yv(end), yv(1)], "k.-", "LineWidth", 1);
            lines = [lines, ltemp];
            set(get(get(ltemp, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
            break;
        end
    
    end

    return;
end