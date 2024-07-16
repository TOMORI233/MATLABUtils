function maximizeFig(Figs)
% Description: maximize figures
% 
% Note: If all figures should be maximized, add this line at the beginning
%       of your script:
%       set(0, "DefaultFigureWindowState", "maximized")
%       To reset the setting, use:
%       set(0, "DefaultFigureWindowState", "factory")

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
