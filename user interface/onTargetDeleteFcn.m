function onTargetDeleteFcn(src, evt)
    % This function is registered as the deleteFcn of an axes target
    % src.UserData.apps is a cell array containing multiple apps

    apps = src.UserData.apps;

    for index = 1:numel(apps)
        app = apps{index};
        if isvalid(app)
            delete(app);
        end
    end
    
    return;
end