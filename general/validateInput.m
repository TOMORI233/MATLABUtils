function v = validateInput(validType, prompt, dataLen, dataRange)
    % Description: loop input until validation pass
    % Input:
    %     validType: string array of valid input data types, including
    %                integer, decimal, string (both string and char), positive,
    %                negative, non-positive, non-negative, odd, even
    %     dataLen: [dataLenMin, dataLenMax] (including upper and lower boundaries)
    %              Empty for no limitation.
    %     dataRange: [dataMin, dataMax] (including upper and lower boundaries)
    %                Empty for no limitation.
    %     prompt: hint of input
    % Output:
    %     inputContent: valid input content

    narginchk(1, 4);

    if nargin < 2
        prompt = 'Input data: ';
    end

    if nargin < 3
        dataLen = [];
    end

    if nargin < 4
        dataRange = [];
    end

    allType = ["integer", "decimal", "string", "positive", "negative",...
               "non-positive", "non-negative", "odd", "even"];
    nTotal = length(validType);
    nPass = 0;

    if nTotal ~= length(find(ismember(validType, allType)))
        error("No matched validation");
    end

    while nPass < nTotal
        nPass = 0;
        v = input(prompt);

        if isempty(v)
            disp('The input should not be empty');
            continue;
        end

        for index = 1:nTotal

            if isa(v, "double")

                if ~isempty(dataLen) && ~(length(v) >= dataLen(1) && length(v) <= dataLen(2))
                    disp(['The input data length should be [', num2str(dataLen(1)), ', ', num2str(dataLen(2)), ']']);
                    break;
                end

                if ~isempty(dataRange) && ~(all(v >= dataRange(1)) && all(v <= dataRange(2)))
                    disp(['The input data range should be within [', num2str(dataRange(1)), ', ', num2str(dataRange(2)), ']']);
                    break;
                end

                switch validType(index)
                    case "integer"
                        nPass = nPass + ~isempty(find(v == fix(v), 1));
                    case "decimal"
                        nPass = nPass + ~isempty(find(v ~= fix(v), 1));
                    case "positive"
                        nPass = nPass + ~isempty(find(v > 0, 1));
                    case "negative"
                        nPass = nPass + ~isempty(find(v < 0, 1));
                    case "non-positive"
                        nPass = nPass + ~isempty(find(v <= 0, 1));
                    case "non-negative"
                        nPass = nPass + ~isempty(find(v >= 0, 1));
                    case "odd"
                        nPass = nPass + ~isempty(find(mod(v, 2) ~= 0, 1));
                    case "even"
                        nPass = nPass + ~isempty(find(mod(v, 2) == 0, 1));
                end

            elseif isstring(v) || ischar(v)
                nPass = nPass + 1;
            end

        end

    end

    return;
end