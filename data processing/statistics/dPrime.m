function [d, beta] = dPrime(pSN, pN)
d = norminv(pSN) - norminv(pN);
beta = normpdf(pSN) / normpdf(pN);
end