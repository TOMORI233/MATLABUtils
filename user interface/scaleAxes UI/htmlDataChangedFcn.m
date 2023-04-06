function htmlDataChangedFcn(src, event, app)
    app.currentRange = src.Data.currentRange;
    
    if strcmp(app.syncOpt, "On")
        scaleAxes(app.target, app.axisName, app.currentRange, "symOpt", app.SymmetricDropDown.Value);
        app.updateCurrentRange;
    end
end