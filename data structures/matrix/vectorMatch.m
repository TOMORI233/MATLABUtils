function match_indices = vectorMatch(whole, part)
% 将向量转换成字符向量
A_str = sprintf('%d', whole);
B_str = sprintf('%d', part);

% 使用strfind查找匹配的起始位置
match_indices = strfind(A_str, B_str);
end
