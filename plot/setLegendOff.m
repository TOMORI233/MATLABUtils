function setLegendOff(target)
set(get(get(target, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');