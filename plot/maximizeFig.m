function maximizeFig(Figs)
    % Description: maximize figures
    narginchk(0, 1);

    if nargin < 1
        Figs = gcf;
    end

    if isa(Figs, "matlab.ui.Figure")
        set(Figs, "WindowState", "maximized");

        % set(Figs, "outerposition", get(0, "screensize")); % not maximized
    else
        error("Input should be figures");
    end

end