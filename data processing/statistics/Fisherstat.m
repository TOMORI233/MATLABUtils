function [H, pFisher, chi_square_stat, sigLevel] = Fisherstat(p, dim, alphaVal)
% Return joint p-value with Fisher's method
% Perform Fisher's method along the N-th dimension of an N-D p-value
% matrix [p].
% For instance, paired t-tests are applied to five paired sample groups,
% which produces a 5-element vector [p]. To tell whether there is a
% difference between the paired samples considering all 5 groups, a joint
% p-value is computed:
% >> [~, pFisher] = Fisherstat(p(:))

narginchk(1, 3);

if nargin < 2
    dim = 1;
end

if nargin < 3
    alphaVal = 0.05;
end

N = size(p, dim) - sum(isnan(p), dim);
df = 2 * (N - 1);
chi_square_stat = -2 * sum(log(p), dim, "omitnan");
pFisher = 1 - chi2cdf(chi_square_stat, df);
sigLevel = chi2inv(1 - alphaVal, df); % uncorrected

H = pFisher < alphaVal;

return;
end