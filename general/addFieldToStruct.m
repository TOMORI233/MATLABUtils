function resStruct = addFieldToStruct(struct,fieldName,fieldVal)
if ~iscell(fieldName)
    fieldName = cellstr(fieldName);
end
%% get length of struct and field names
    structLength = length(struct);
    oldFields = fields(struct);
    %% convert struct to cell
    oldCell = struct2cell(struct); 
    %% check if oldCell is column director, otherwise ,invert
    [m n] = size(oldCell); 
    if n == structLength
        oldCell = oldCell';
    end
    %% check if new cell to add is the same length with structure
    [mm nn] = size(fieldVal);
    if mm ~= structLength 
        error('the length of new cell is not suitable with the structrue');
    end
    
    %% merge old and new cells and creat new sutruct
    resCell = [oldCell fieldVal];
    resField = [oldFields; fieldName];
    resStruct = easyStruct(resField,resCell);
end
    


