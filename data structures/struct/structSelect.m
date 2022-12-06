function sNew = structSelect(s, fieldSel)
    if iscell(fieldSel)
        fieldSel = string(fieldSel);
    end
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
end
