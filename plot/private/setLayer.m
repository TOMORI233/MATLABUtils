function setLayer(obj, tar, Layer)
    % search all children in obj
    objChildren = obj.Children;
    idx0 = arrayfun(@(x) isequal(class(x), class(tar)), objChildren);
    idx = find(objChildren == tar, 1);
    idx1 = find(idx0, 1, "first");
    idx2 = find(idx0, 1, "last");

    if isempty(idx)
        error("Target object is not in target obj");
    end
    
    if strcmpi(Layer, "bottom")
        if idx == idx2
            return;
        end
        set(obj, "Children", [objChildren(1:idx - 1); objChildren(idx + 1:idx2); tar; objChildren(idx2 + 1:end)]);
    elseif strcmpi(Layer, "top")
        if idx == idx1
            return;
        end
        set(obj, "Children", [objChildren(1:idx1 - 1); tar; objChildren(idx1:idx - 1); objChildren(idx + 1:end)]);
    end

    return;
end