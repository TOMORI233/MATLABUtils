function maximizeFig(h)
    warning off;
    jFrame = get(h, "JavaFrame");
    set(jFrame, "Maximized", 1);
end