function maximizeFig(Figs)
% Description: maximize figures
narginchk(0, 1);

if nargin < 1
    Figs = gcf;
end

<<<<<<< HEAD
warning off;

for index = 1:length(Figs)

    if strcmpi(get(Figs(index), "Visible"), "on")
        try
            jFrame = get(Figs(index), "JavaFrame");
            set(jFrame, "Maximized", 1);
        catch e
            disp(e.message);
            set(Figs(index), "outerposition", get(0, "screensize"));
        end
    else
        set(Figs(index), "outerposition", get(0, "screensize"));
=======
    if isa(Figs, "matlab.ui.Figure")
        set(Figs, "WindowState", "maximized");

        % set(Figs, "outerposition", get(0, "screensize")); % not maximized
    else
        error("Input should be figures");
>>>>>>> 633016e1f8510acdcef5e395721bbf95010b0ad0
    end

end

end