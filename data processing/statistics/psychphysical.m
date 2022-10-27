function [d, beta] = psychphysical(pSN, pN)
d = norminv(pSN) - norminv(pN);
beta = normpdf(pSN) / normpdf(pN);
end