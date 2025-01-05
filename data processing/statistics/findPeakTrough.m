function [peakIdx, troughIdx] = findPeakTrough(data, varargin)
% Description: find indices (in logical) of peak and trough of waves
% Input:
%     data: a vector or 2-D matrix
%     dim: 1 for data of [nSample, nCh], 2 for data of [nCh, nSample] (default: 2)
% Output:
%     peakIdx/troughIdx: logical [nCh, nSample]

mIp = inputParser;
mIp.addRequired("data", @(x) validateattributes(x, {'numeric'}, {'2d'}));
mIp.addOptional("dim", 2, @(x) ismember(x, [1, 2]));
mIp.parse(data, varargin{:});

dim = mIp.Results.dim;

if isvector(data)
    data = reshape(data, [1, numel(data)]);
else
    data = permute(data, [3 - dim, dim]);
end

peakIdx = cell2mat(rowFcn(@ispeak, data, "UniformOutput", false));
troughIdx = cell2mat(rowFcn(@istrough, data, "UniformOutput", false));
return;
end

%%
function y = ispeak(data)
y = false(1, length(data));
y(find(diff(sign(diff(data))) == -2) + 1) = true;
% 遍历数据，寻找连续相等的序列
i = 2;
while i < length(data)
    if data(i) == data(i-1)
        % 找到连续相等值的开始和结束索引
        start = i-1;
        while i <= length(data) && data(i) == data(i-1)
            i = i + 1;
        end
        finish = i - 1;

        % 检查序列前后的值，判断是否为峰值
        if (start == 1 || data(start-1) < data(start)) && (finish == length(data) || data(finish+1) < data(finish))
            y(start) = true;
        end
    else
        i = i + 1;
    end
end
return;
end

function y = istrough(data)
y = false(1, length(data));
y(find(diff(sign(diff(data))) == 2) + 1) = true;

% 遍历数据，寻找连续相等的序列
i = 2;
while i < length(data)
    if data(i) == data(i-1)
        % 找到连续相等值的开始和结束索引
        start = i-1;
        while i <= length(data) && data(i) == data(i-1)
            i = i + 1;
        end
        finish = i - 1;

        % 检查序列前后的值，判断是否为波谷
        if (start == 1 || data(start-1) > data(start)) && (finish == length(data) || data(finish+1) > data(finish))
            y(start) = true;
        end
    else
        i = i + 1;
    end
end

return;
end