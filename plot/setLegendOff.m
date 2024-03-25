function setLegendOff(target)

    for index = 1:numel(target)
        set(get(get(target(index), 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    end

    return;
end