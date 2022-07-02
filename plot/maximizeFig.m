function maximizeFig(Fig)
    % Description: maximize a figure
    
    try
        jFrame = get(Fig, "JavaFrame");
        set(jFrame, "Maximized", 1);
    catch e
        disp(e.message);
        set(Fig, "outerposition", get(0, "screensize"));
    end

end