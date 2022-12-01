function plotSize = autoPlotSize(num)
    F = figure("visible", "off");
    t = tiledlayout("flow");
    for i = 1 : num
        nexttile
    end
    pause(0.01);
    plotSize =  t.GridSize;
    close(F);

         
