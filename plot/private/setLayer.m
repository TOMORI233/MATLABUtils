function setLayer(ax, tar, Layer)
    % search all children in ax
    idx = allchild(ax) == tar;

    if ~any(idx)
        error("Target object is not in target axes");
    end
    
    if strcmpi(Layer, "bottom")
        set(ax, "Children", [tar; ax.Children(~idx)]);
    elseif strcmpi(Layer, "top")
        set(ax, "Children", [ax.Children(~idx); tar]);
    end

    return;
end