function mAxe = mSubplot(varargin)
% Description: extension of function subplot
% Input:
%     Fig: figure to place subplot
%     row/col/index: same usage of function subplot
%     nSize: [nX, nY] specifies size of subplot (default: [1, 1])
%     margins/paddings: same definition in HTML and CSS
%     alignment: name-value with options 'top-left'(default), 'top-right', 'bottom-left',
%                'bottom-right'. RECOMMEND: use with [nSize]
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
mIp.addParameter("nSize", [1, 1], @(x) validateattributes(x, 'numeric', {'vector'}));
mIp.addParameter("margins", 0.01 * ones(1, 4), @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
mIp.addParameter("paddings", 0.01 * ones(1, 4), @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
mIp.addParameter("alignment", 'top-left', @(x) any(validatestring(x, {'top-left', 'top-right', 'bottom-left', 'bottom-right'})));
mIp.parse(Fig, varargin{:});

Fig       = mIp.Results.Fig;
row       = mIp.Results.row;
col       = mIp.Results.col;
index     = mIp.Results.index;
alignment = mIp.Results.alignment;
nSize     = getOr(mIp.Results, "nSize0",     mIp.Results.nSize,     true);
margins   = getOr(mIp.Results, "margins0",   mIp.Results.margins,   true);
paddings  = getOr(mIp.Results, "paddings0",  mIp.Results.paddings,  true);

% nSize = [nX, nY]
nX = nSize(1);

if numel(nSize) == 1
    nY = 1;
elseif numel(nSize) == 2
    nY = nSize(2);
else
    error('nSize input should be a 2-element double vector');
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

divX = paddings(1) + divWidth * (cIndex - 1);
divY = 1 - paddings(4) - divHeight * (rIndex + nY - 1);
axeWidth  = (1 - margins(1) - margins(2)) * divWidth  * nX;
axeHeight = (1 - margins(3) - margins(4)) * divHeight * nY;
axeX = divX + margins(1) * divWidth * nX;
axeY = divY + margins(3) * divHeight * nY;

switch alignment
    case 'bottom-left'
        mAxe = axes(Fig, "Position", [axeX, axeY - (divHeight - axeHeight), axeWidth, axeHeight], "Box", "on");
    case 'bottom-right'
        mAxe = axes(Fig, "Position", [axeX + divWidth - axeWidth, axeY - (divHeight - axeHeight), axeWidth, axeHeight], "Box", "on");
    case 'top-left'
        mAxe = axes(Fig, "Position", [axeX, axeY, axeWidth, axeHeight], "Box", "on");
    case 'top-right'
        mAxe = axes(Fig, "Position", [axeX + divWidth - axeWidth, axeY, axeWidth, axeHeight], "Box", "on");
    otherwise
        error('Invalid alignment input');
end

return;
end
