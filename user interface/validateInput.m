function v = validateInput(prompt, varargin)
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
    %     s = validateInput('Input a name from the list: ', @(x) any(validatestring(x, nameList)), 's');

    mIp = inputParser;
    mIp.addRequired("prompt", @isstr); %#ok<*DISSTR>
    mIp.addOptional("arg2", [], @(x) isa(x, 'function_handle') || any(validatestring(x, {'s'})));
    mIp.addOptional("sInput", [], @(x) validatestring(x, {'s'}));
    mIp.parse(prompt, varargin{:});

    arg2 = mIp.Results.arg2;

    switch class(arg2)
        case 'function_handle'
            validateFcn = arg2;
            sInput = mIp.Results.sInput;
        case 'char'
            validateFcn = [];
            sInput = arg2;
        case 'string'
            validateFcn = [];
            sInput = arg2;
    end

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