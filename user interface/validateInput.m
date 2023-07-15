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
    %     % 3. use UI instead of command line
    %     v = validateInput("Input an integer", @(x) x == fix(x), "UI", "on");

    mIp = inputParser;
    mIp.addRequired("prompt", @(x) ischar(x) || isstring(x));
    mIp.addOptional("arg2", [], @(x) isa(x, 'function_handle') || any(validatestring(x, {'s'})));
    mIp.addOptional("sInput", [], @(x) any(validatestring(x, {'s'})));
    mIp.addParameter("UI", "off", @(x) any(validatestring(x, {'on', 'off'})));
    mIp.parse(prompt, varargin{:});

    arg2 = mIp.Results.arg2;
    uiOpt = mIp.Results.UI;

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
                if strcmpi(uiOpt, "off")
                    v = input(prompt, "s");
                else
                    app = validateInputUI(prompt, validateFcn, "s");
                    v = app.res;
                    delete(app);
                end
            else
                if strcmpi(uiOpt, "off")
                    v = input(prompt);
                else
                    app = validateInputUI(prompt, validateFcn, []);
                    v = app.res;
                    delete(app);
                end
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