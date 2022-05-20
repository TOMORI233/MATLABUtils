function res = cellSum(data,varargin)
    [m , n] = size(data);
    if n == 1
        direction = 1; % 1: m*n to 1*n | 2: m*n to m*1
    else
        direction = 2; % 1: m*n to 1*n | 2: m*n to m*1
    end

    for i = 1:2:length(varargin)
    eval([varargin{i} '=varargin{i+1};']);
    end
    
    
    switch direction
        case 1
            for i = 1 : n
                res{1 , i} = zeros(size(data{1}));
                for j = 1 : m
                    res{1 , i} = res{1 , i} + data{i , j};
                end
            end
        case 2
            for i = 1 : m
                res{i , 1} = zeros(size(data{1}));
                for j = 1 : n
                    res{i , 1} = res{i , 1} + data{i , j};
                end
            end
        case 0
            res{1 , 1} = zeros(size(data{1}));
            for i = 1 : m
                for j = 1 : n
                    res{1 , 1} = data{i , j};
                end
            end
    end
end
                
    
    
    