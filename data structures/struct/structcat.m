function sRes = structcat(varargin)
if length(varargin{1}) > 1
    cellVal = cellfun(@(x) table2cell(struct2table(x)), varargin, "UniformOutput", false);
    cellVal = [cellVal{:}];
    cellField = cellfun(@(x) fields(x), varargin, "UniformOutput", false)';
    cellField = vertcat(cellField{:})';
    sRes = cell2struct(cellVal, cellField, 2);
else
    cellVal = cellfun(@(x) struct2cell(x), varargin, "UniformOutput", false);
    cellVal = vertcat(cellVal{:});
    cellField = cellfun(@(x) fields(x), varargin, "UniformOutput", false)';
    cellField = vertcat(cellField{:})';
    sRes = cell2struct(cellVal, cellField, 1);
end
end