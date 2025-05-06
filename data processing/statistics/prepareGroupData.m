function [res, tbl] = prepareGroupData(varargin)
% prepare group data for ANOVA

N = cellfun(@numel, varargin);
varargin = cellfun(@(x) x(:), varargin, "UniformOutput", false);
X = cat(1, varargin{:});
G = arrayfun(@(x, y) y * ones(x, 1), N, 1:length(N), "UniformOutput", false);
G = cat(1, G{:});
res = [X, G];
tbl = table(X(:), categorical(string(char('A' + G - 1))), 'VariableNames', {'y', 'group'});

return;
end