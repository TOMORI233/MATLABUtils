function v = validateInput(varargin)
    % Description: loop input until validation pass
    % Input:
    %     prompt: hint of input
    %     validateFcn: validate function handle
    %     sInput: input type, "s" or 's' for str input and left empty for other type input
    % Output:
    %     v: valid input content
    % Example:
    %     % 1. numeric input
    %     k = validateInput('Input a k for kmeans: ', ...
    %                       @(x) validateattributes(x, 'numeric', ...
    %                       {'numel', 1, 'positive', 'integer'}));
    %     % 2. str input
    %     nameList = {'Mike', 'John', 'Penny'};
    %     s = validateInput('Input a name from the list: ', @(x) validatestring(x, nameList), 's');

    mIp = inputParser;
    mIp.addOptional("prompt", '', @isstr); %#ok<*DISSTR>
    mIp.addOptional("validateFcn", [], @(x) isa(x, 'function_handle'));
    mIp.addOptional("sInput", [], @(x) validatestring(x, {'s'}));
    mIp.parse(varargin{:});

    prompt = mIp.Results.prompt;
    validateFcn = mIp.Results.validateFcn;
    sInput = mIp.Results.sInput;

    e.message = 'error';

    while ~isempty(e)

        try
            
            if ~isempty(sInput)
                v = input(prompt, "s");
            else
                v = input(prompt);
            end
    
            if ~isempty(validateFcn)
                validateFcn(v);
            end

            e = [];
        catch e
            disp(e.message);
        end

    end

    return;
end