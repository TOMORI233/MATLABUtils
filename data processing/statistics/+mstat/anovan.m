function [p, stats, effectSize, bf10, tbl] = anovan(x, group, varargin)
% N-way ANOVA with Bayes factor output
% Inputs:
%   x      - S*1 vector
%   group  - S*N cell, each column is a factor
% Outputs:
%   p           - p-values for each main and interaction effect
%   stats       - ANOVA table output
%   effectSize  - eta-squared for each effect
%   bf10        - Bayes factor for the full model
%   tbl         - anova table

x = x(:);
nFactors = size(group, 2);

T = table;
T.Y = x;
varNames = cell(1, nFactors);
for index = 1:nFactors
    fname = ['F' num2str(index)];
    if iscategorical(group)
        T.(fname) = group(:, index);
    elseif isnumeric(group)
        T.(fname) = categorical(group(:, index));
    elseif iscell(group)
        T.(fname) = categorical(group{:, index});
    end
    varNames{index} = fname;
end

factorTerms = strjoin(varNames, ' + ');
interactions = {};
if nFactors >= 2
    combos = nchoosek(1:nFactors, 2);
    for index = 1:size(combos,1)
        f1 = ['F' num2str(combos(index,1))];
        f2 = ['F' num2str(combos(index,2))];
        interactions{end + 1} = [f1 '*' f2]; %#ok<AGROW>
    end
end
interactionTerms = strjoin(interactions, ' + ');
if ~isempty(interactionTerms)
    fullFormula = ['Y ~ ' factorTerms ' + ' interactionTerms];
else
    fullFormula = ['Y ~ ' factorTerms];
end

% classical ANOVA
[p, tbl, stats] = anovan(x, group, varargin{:});

% effect size
if nFactors == 1
    effectSize = eta_squared(tbl);
else
    effectSize = arrayfun(@(x) eta_squared_partial(tbl, x), (1:nFactors)');
end

% Bayes Factor
try
    bf10 = bf.anova(T, fullFormula);
catch
    warning('bf.anova failed. bf10 set to NaN.');
    bf10 = NaN;
end

return;
end