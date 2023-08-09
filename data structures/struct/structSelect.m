function sNew = structSelect(s, fieldSel)
fieldSel = string(fieldSel);
if length(s) > 1
    sField = fields(s);
    wrongIdx = find(~ismember(fieldSel, sField));
    if ~isempty(wrongIdx)
        error(strcat(strjoin(fieldSel(wrongIdx), ","), " is not a field in the old structure!"));
    end

    [~, selectIdx] = ismember(fieldSel, sField);

    structLength = length(s);
    oldCell = table2cell(struct2table(s));
    [m, n] = size(oldCell);
    if n == structLength
        oldCell = oldCell';
    end

    if ~isCellByCol(oldCell)
        oldCell = oldCell';
    end

    valueSel = oldCell(:, selectIdx);

    sNew = easyStruct(fieldSel, valueSel);
else
    for sIndex = 1 : length(fieldSel)
        sNew.(fieldSel(sIndex)) = s.(fieldSel(sIndex));
    end
end
end
