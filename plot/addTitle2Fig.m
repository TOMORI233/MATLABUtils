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
    mIp.addRequired("str", @(x) isStringScalar(x) || ischar(x));
    mIp.addParameter("HorizontalAlignment", 'center', @(x) any(validatestring(x, {'left', 'right', 'center'})));
    mIp.addParameter("Position", [0.5, 1.1], @(x) validateattributes(x, {'numeric'}, {'numel', 2}));
    mIp.addParameter("FontSize", 14, @(x) validateattributes(x, {'numeric'}, {'scalar', 'integer', 'positive'}));
    mIp.addParameter("FontWeight", 'normal', @(x) any(validatestring(x, {'normal', 'bold'})));
    mIp.parse(Fig, varargin{:});

    str = mIp.Results.str;
    alignment = mIp.Results.HorizontalAlignment;
    pos = mIp.Results.Position;
    fontSize = mIp.Results.FontSize;
    fontWeight = mIp.Results.FontWeight;

    mAxes = mSubplot(Fig, 1, 1, 1);
    T = text(mAxes, pos(1), pos(2), str, "FontSize", fontSize, "FontWeight", fontWeight, "HorizontalAlignment", alignment);
    set(mAxes, "Visible", "off");

    return;
end