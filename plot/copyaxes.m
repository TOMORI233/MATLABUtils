function copyaxes(source, target)
    targetFigure = get(target, "Parent");
    obj = copyobj(source, targetFigure);
    set(obj, "Position", get(target, "Position"));
    delete(target);
end