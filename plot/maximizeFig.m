function maximizeFig(Figs)
% Description: maximize figures
narginchk(0, 1);

if nargin < 1
    Figs = gcf;
end

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
    end

end

end