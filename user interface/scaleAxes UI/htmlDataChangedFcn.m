function htmlDataChangedFcn(src, event, app)
    app.currentRange = src.Data.currentRange;
    
    if strcmp(app.syncOpt, "On")
        scaleAxes(app.target, app.axesName, app.currentRange);
        app.updateCurrentRange;
    end
end