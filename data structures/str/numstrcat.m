function result = numstrcat(numArray, connector)
    % Transfer a double array to a string of rational numbers connected with the input connector
    % e.g. Using ',' as the connector:
    % [0.2 0.2 0.2 0.2 0.2] -> '1/5,1/5,1/5,1/5,1/5'
    numArray = reshape(numArray, [numel(numArray), 1]);
    numArrayStr = string(num2str(rats(numArray)));
    result = strrep(numArrayStr(1), ' ', '');

    for index = 2:size(numArrayStr, 1)
        result = strcat(result, connector, strrep(numArrayStr(index), ' ', ''));
    end

    return;
end
