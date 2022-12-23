function [valInfo, opts] = getTableValType(xlsxPath, ID)
narginchk(1, 2);
if nargin < 2
    ID = "0";
end

opts = detectImportOptions(xlsxPath);
opts = setvartype(opts, 'string');
configTable = table2struct(readtable(xlsxPath, opts));
dataType = configTable(ismember([configTable.ID]', ID));
dataType = rmfield(dataType, "ID");

valNames = fields(dataType);
valTypes = string(struct2cell(dataType));
[valType, ~, idx] = unique(valTypes);

opts = detectImportOptions(xlsxPath);
for vIndex = 1:length(valType)
    valInfo(vIndex).valType = valType(vIndex);
    valInfo(vIndex).valName = valNames(idx == vIndex);
    opts = setvartype(opts, valInfo(vIndex).valName, valInfo(vIndex).valType);
end
