function S = structcat(varargin)
% Concatenate input struct arrays, left empty for fields with conflict.
% Concatenate n1*1 struct [A1] with n2*1 struct [A2] with structcat, you will
% get an (n1+n2)*1 struct.
% 
% Example:
%     A = struct("a", {1; 2; 3; 4});
%     B = struct("a", {11; 12; 13; 14}), ...
%                "b", {101; 102; 103; 104});
%     C = structcat(A, B)
%     returns C as a 8*1 struct with fields "a" and "b"
%     >> C.a =  1,  2,  3,  4,  11,  12,  13,  14
%     >> C.b = [], [], [], [], 101, 102, 103, 104

S = varargin;

if ~any(cellfun(@(x) isvector(x) && isstruct(x), S))
    error("structcat(): input should be struct array");
end

% Make sure all [S] are column vector
S = cellfun(@(x) reshape(x, [numel(x), 1]), S, "UniformOutput", false)';

fNames = unique(cellcat(1, cellfun(@fieldnames, S, "UniformOutput", false)), "stable");
emptyVals = cell(length(fNames), 1);
temp = [fNames, emptyVals]';
emptyStruct = struct(temp{:});
S = cellfun(@(x) arrayfun(@(y) getOrFull(y, emptyStruct), x), S, "UniformOutput", false);
S = cat(1, S{:});
return;
end