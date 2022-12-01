function maximizeFig(Fig)
    % Description: maximize a figure
    narginchk(0, 1);

    if nargin < 1
        Fig = gcf;
    end

    warning off;
    
    try
        jFrame = get(Fig, "JavaFrame");
        set(jFrame, "Maximized", 1);
    catch e
        disp(e.message);
        set(Fig, "outerposition", get(0, "screensize"));
    end

end