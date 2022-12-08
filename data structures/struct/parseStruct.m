function parseStruct(S, sIndex)
narginchk(1, 2)
if nargin < 2
    sIndex = 1 : length(S);
end
sField = fields(S);
for fIndex = 1 : length(sField)
    % add local var to base workspace
    eval(['assignin(''base'', ''', sField{fIndex}, ''', vertcat(S(sIndex).', sField{fIndex}, '));']);
end
