function T = addTitle2Fig(varargin)
    % Description: add a total title to the figure

    if strcmp(class(varargin{1}), "matlab.ui.Figure")
        Fig = varargin{1};
        varargin = varargin(2:end);
    else
        Fig = gcf;
    end

    mIp = inputParser;
    mIp.addRequired("Fig", @(x) isa(x, "matlab.ui.Figure"));
    mIp.addRequired("str", @(x) isStringScalar(x) || (ischar(x) && isStringScalar(string(x))));
    mIp.addParameter("HorizontalAlignment", 'center', @(x) any(validatestring(x, {'left', 'right', 'center'})));
    mIp.addParameter("Position", [0.5, 1.1], @(x) validateattributes(x, {'numeric'}, {'numel', 2}));
    mIp.addParameter("FontSize", 14, @(x) validateattributes(x, {'numeric'}, {'scalar', 'integer', 'positive'}));
    mIp.addParameter("FontWeight", 'normal', @(x) any(validatestring(x, {'normal', 'bold'})));
    mIp.addParameter("Interpreter", "none", @(x) any(validatestring(x, {'none', 'tex', 'latex'})))
    mIp.parse(Fig, varargin{:});

    str = mIp.Results.str; % title string
    alignment = mIp.Results.HorizontalAlignment; % left | center | right
    pos = mIp.Results.Position; % normalized [x, y]
    fontSize = mIp.Results.FontSize;
    fontWeight = mIp.Results.FontWeight;
    interpreter = mIp.Results.Interpreter;

    mAxes = mSubplot(Fig, 1, 1, 1);
    T = text(mAxes, pos(1), pos(2), str, ...
             "FontSize", fontSize, ...
             "FontWeight", fontWeight, ...
             "HorizontalAlignment", alignment, ...
             "Interpreter", interpreter);
    setLayer(Fig, mAxes, "bottom");
    set(mAxes, "Visible", "off");
    mAxes.Toolbar.Visible = "off";

    return;
end