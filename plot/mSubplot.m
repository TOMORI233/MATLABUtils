function varargout = mSubplot(varargin)
    % Description: extension of function subplot
    % Input:
    %     Fig: figure to place subplot
    %     row/col/index: same usage of function subplot
    %     nSize: [nX, nY] specifies size of subplot (default: [1, 1])
    %     margins: margins of subplot
    %     paddings: paddings of subplot
    %     shape: 'auto'(default), 'square-min', 'square-max', 'fill'
    %            (NOTICE: 'fill' option is prior to [margins] and [nSize] options)
    %     alignment: (RECOMMEND: use with [nSize]) name-value with options:
    %                'top-left',
    %                'top-right',
    %                'bottom-left',
    %                'bottom-right',
    %                'center-left',
    %                'center-right',
    %                'top-center',
    %                'bottom-center',
    %                'center'(default).
    % Output:
    %     mAxe: subplot axes object

    if strcmp(class(varargin{1}), "matlab.ui.Figure") || strcmp(class(varargin{1}), "matlab.graphics.Graphics")
        Fig = varargin{1};
        varargin = varargin(2:end);
    else
        Fig = gcf;
    end

    mIp = inputParser;
    mIp.addRequired("Fig", @isgraphics);
    mIp.addRequired("row", @(x) validateattributes(x, 'numeric', {'numel', 1, 'positive', 'integer'}));
    mIp.addRequired("col", @(x) validateattributes(x, 'numeric', {'numel', 1, 'positive', 'integer'}));
    mIp.addRequired("index", @(x) validateattributes(x, 'numeric', {'numel', 1, 'positive', 'integer'}));
    mIp.addOptional("nSize0", [], @(x) validateattributes(x, 'numeric', {'vector'}));
    mIp.addOptional("margins0", [], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
    mIp.addOptional("paddings0", [], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
    mIp.addOptional("shape0", [], @(x) any(validatestring(x, {'auto', 'square-min', 'square-max', 'fill'})));
    mIp.addParameter("nSize", [1, 1], @(x) validateattributes(x, 'numeric', {'vector'}));
    mIp.addParameter("margins", [0.05, 0.05, 0.08, 0.05], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
    mIp.addParameter("paddings", [0.03, 0.03, 0.08, 0.05], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
    mIp.addParameter("shape", "auto", @(x) any(validatestring(x, {'auto', 'square-min', 'square-max', 'fill'})));
    mIp.addParameter("alignment", 'center', @(x) any(validatestring(x, {'top-left', ...
                                                                          'top-right', ...
                                                                          'bottom-left', ...
                                                                          'bottom-right', ...
                                                                          'top-center', ...
                                                                          'bottom-center', ...
                                                                          'center-left', ...
                                                                          'center-right', ...
                                                                          'center'})));
    mIp.parse(Fig, varargin{:});

    Fig = mIp.Results.Fig;
    row = mIp.Results.row;
    col = mIp.Results.col;
    index = mIp.Results.index;
    alignment = mIp.Results.alignment;
    nSize = getOr(mIp.Results, "nSize0", mIp.Results.nSize, true);
    margins = getOr(mIp.Results, "margins0", mIp.Results.margins, true);
    paddings = getOr(mIp.Results, "paddings0", mIp.Results.paddings, true);
    shape = getOr(mIp.Results, "shape0", mIp.Results.shape, true);

    % nSize = [nX, nY]
    nX = nSize(1);

    if numel(nSize) == 1
        nY = 1;
    elseif numel(nSize) == 2
        nY = nSize(2);
    else
        error('nSize input should be a scalar or a 2-element double vector');
    end

    % paddings or margins is [Left, Right, Bottom, Top]
    divWidth  = (1 - paddings(1) - paddings(2)) / col;
    divHeight = (1 - paddings(3) - paddings(4)) / row;
    rIndex = ceil(index / col);

    if rIndex > row
        error('index > col * row');
    end

    cIndex = mod(index, col);

    if cIndex == 0
        cIndex = col;
    end

    divX = paddings(1) + divWidth  * (cIndex - 1);
    divY = paddings(3) + divHeight * (row - rIndex);
    axeWidth  = (1 - margins(1) - margins(2)) * divWidth  * nX;
    axeHeight = (1 - margins(3) - margins(4)) * divHeight * nY;
    borderMin = min([axeWidth, axeHeight]);
    borderMax = max([axeWidth, axeHeight]);

    FigSize = get(0, "screensize"); % for maximized figure size
    % FigSize = get(Fig, "OuterPosition"); % for original figure size
    adjIdx = FigSize(4) / FigSize(3);

    switch shape
        case 'auto'
            % default: without adjustment
        case 'square-min'
            axeWidth  = borderMin * adjIdx;
            axeHeight = borderMin;
        case 'square-max'
            axeWidth  = borderMax * adjIdx;
            axeHeight = borderMax;
        case 'fill'
            mAxe = axes(Fig, "Position", [divX, divY, divWidth, divHeight]);

            if nargout == 1
                varargout{1} = mAxe;
            end

            return;
        otherwise
            error('Invalid shape input');
    end

    switch alignment
        case 'bottom-left'
            axeX = divX + margins(1) * divWidth;
            axeY = divY + margins(3) * divHeight;
        case 'bottom-right'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth);
            axeY = divY + margins(3) * divHeight;
        case 'top-left'
            axeX = divX + margins(1) * divWidth;
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight);
        case 'top-right'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth);
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight);
        case 'center-left'
            axeX = divX + margins(1) * divWidth;
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight) / 2;
        case 'center-right'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth);
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight) / 2;
        case 'top-center'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth)  / 2;
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight);
        case 'bottom-center'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth)  / 2;
            axeY = divY + margins(3) * divHeight;
        case 'center'
            axeX = divX + margins(1) * divWidth  + (divWidth  * (1 - margins(1) - margins(2)) - axeWidth)  / 2;
            axeY = divY + margins(3) * divHeight + (divHeight * (1 - margins(3) - margins(4)) - axeHeight) / 2;
        otherwise
            error('Invalid alignment input');
    end

    mAxe = axes(Fig, "Position", [axeX, axeY, axeWidth, axeHeight]);

    if nargout == 1
        varargout{1} = mAxe;
    end

    return;
end
