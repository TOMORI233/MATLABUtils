function onTargetDeleteFcn(src, event, app)

    if isvalid(app) && any(~isvalid(app.target))
        delete(app);
    end
    
end