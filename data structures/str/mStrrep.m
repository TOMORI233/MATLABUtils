function mStrrep(strings, olds, news)
strings = string(strings);
outString = reshape(strings, 1, []);
for sIndex = 1 : length(olds)
    idx = matches(outString, olds(sIndex));
    outString(idx) = news(sIndex);
end
outString = reshape(outString, size(strings, 1), size(strings, 2));
end