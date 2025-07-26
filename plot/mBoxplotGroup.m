function varargout = mBoxplotGroup(varargin)
% MBOXPLOTGROUP Custom grouped boxplot visualization with advanced styling options
%
%   ax = mBoxplotGroup(X) creates a grouped boxplot of the data in cell array X,
%   where each cell contains a matrix representing one group (columns = categories).
%   Returns the handle to the axes object.
%
%   ax = mBoxplotGroup(ax, X) plots into specified axes handle.
%
%   ax = mBoxplotGroup(..., Name, Value) specifies additional options:
%
%   DATA SPECIFICATION:
%     'X'               - Cell array of matrices (required). Each cell represents a group, 
%                         columns represent categories within groups.
%
%   GROUPING CONTROLS:
%     'GroupLabels'     - Cell array of strings for group labels (primary labels)
%     'CategoryLabels'  - Cell array of strings for category labels (secondary labels)
%     'CategoryLegends' - Cell array of strings for legend entries (per category)
%     'GroupSpace'      - Spacing between groups (default: 0.3)
%     'CategorySpace'   - Spacing between categories within groups (default: 0.2)
%     'GroupLines'      - Show vertical lines between groups (logical, default: false)
%
%   BOX APPEARANCE:
%     'BoxEdgeType'     - Box edge calculation: 'SE', 'STD', or [low,high] percentiles
%     'Whisker'         - Whisker percentiles [low,high] (default: [10,90])
%     'Colors'          - Color specification (single color, cell array, or colormap)
%     'BoxParameters'   - Cell array of patch properties for boxes
%     'CenterLineParameters' - Properties for center lines (mean/median)
%
%   DATA POINTS:
%     'IndividualDataPoint' - 'show' or 'hide' individual points (default: 'show')
%     'SymbolParameters'    - Properties for individual data points
%     'Jitter'             - Amount of horizontal jitter (default: 0.1)
%
%   EXAMPLE:
%     data = {randn(50,2), randn(60,2)}; % 2 groups, 2 categories each
%     mBoxplotGroup(data, ...
%         'GroupLabels', {'Control','Treatment'}, ...
%         'CategoryLabels', {'Method A','Method B'}, ...
%         'BoxEdgeType', [25 75], ...
%         'Whisker', [5 95], ...
%         'Colors', lines(2));
%
%   NOTES:
%     - For box edges: 'SE' uses mean±SE, 'STD' uses mean±STD, or specify percentiles
%     - Category legends only shown if 'CategoryLegends' specified
%     - Default point size is 36 (in points^2)

% Copyright (c) 2025 HX Xu. All rights reserved.

if isgraphics(varargin{1}(1), "axes")
    ax = varargin{1}(1);
    varargin = varargin(2:end);
else
    ax = gca;
end

defaultBoxParameters = {"LineStyle", "-", ...
                        "LineWidth", 0.5, ...
                        "FaceColor", "none", ...
                        "FaceAlpha", 1};
defaultCenterLineParameters = {"Type", "Mean", ...
                               "LineStyle", "-", ...
                               "LineWidth", 0.5, ...
                               "Color", "auto"};
defaultWhiskerParameters = {"LineStyle", "-", ...
                            "LineWidth", 0.5, ...
                            "Color", "auto"};
defaultWhiskerCapParameters = {"LineStyle", "-", ...
                               "LineWidth", 0.5, ...
                               "Color", "auto", ...
                               "Width", 0.4};
defaultSymbolParameters = {"Marker", "o", ...
                           "MarkerEdgeColor", "w", ...
                           "MarkerFaceColor", "auto", ...
                           "MarkerFaceAlpha", 0.3, ...
                           "SizeData", 36, ...
                           "LineWidth", 0.1};

mIp = inputParser;
mIp.addRequired("ax", @(x) isgraphics(x, "axes"));
mIp.addRequired("X", @(x) validateattributes(x, 'cell', {'vector'}));
mIp.addParameter("GroupLabels", '');
mIp.addParameter("GroupSpace", 0.3, @(x) validateattributes(x, 'numeric', {'scalar'}));
mIp.addParameter("GroupLines", false, @(x) validateattributes(x, 'logical', {'scalar'}));
mIp.addParameter("CategoryLabels", '');
mIp.addParameter("CategoryLegends", '');
mIp.addParameter("CategorySpace", 0.2, @(x) validateattributes(x, 'numeric', {'scalar'}));
mIp.addParameter("Colors", [1, 0, 0]);
mIp.addParameter("BoxEdgeType", "SE");
mIp.addParameter("Whisker", [10, 90]);
mIp.addParameter("BoxParameters", defaultBoxParameters, @(x) iscell(x));
mIp.addParameter("CenterLineParameters", defaultCenterLineParameters, @(x) iscell(x));
mIp.addParameter("WhiskerParameters", defaultWhiskerParameters, @(x) iscell(x));
mIp.addParameter("WhiskerCapParameters", defaultWhiskerCapParameters, @(x) iscell(x));
mIp.addParameter("IndividualDataPoint", "show", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.addParameter("SymbolParameters", defaultSymbolParameters, @(x) iscell(x));
mIp.addParameter("Jitter", 0.1, @(x) validateattributes(x, 'numeric', {'scalar'}));

mIp.parse(ax, varargin{:});

X = mIp.Results.X;
GroupLabels = cellstr(mIp.Results.GroupLabels);
GroupSpace = mIp.Results.GroupSpace;
GroupLines = mIp.Results.GroupLines;
CategoryLabels = cellstr(mIp.Results.CategoryLabels);
CategoryLegends = cellstr(mIp.Results.CategoryLegends);
CategorySpace = mIp.Results.CategorySpace;
Colors = mIp.Results.Colors;
BoxEdgeType = mIp.Results.BoxEdgeType;
BoxParameters = getOrCellParameters(mIp.Results.BoxParameters, defaultBoxParameters);
CenterLineParameters = getOrCellParameters(mIp.Results.CenterLineParameters, defaultCenterLineParameters);
Whisker = mIp.Results.Whisker;
WhiskerParameters = getOrCellParameters(mIp.Results.WhiskerParameters, defaultWhiskerParameters);
WhiskerCapParameters = getOrCellParameters(mIp.Results.WhiskerCapParameters, defaultWhiskerCapParameters);
IndividualDataPoint = mIp.Results.IndividualDataPoint;
SymbolParameters = getOrCellParameters(mIp.Results.SymbolParameters, defaultSymbolParameters);
Jitter = mIp.Results.Jitter;

% Validate
X = X(:);
nCategory = cellfun(@(x) size(x, 2), X);
nGroup = numel(X);
if ~isempty(Whisker)
    validateattributes(Whisker, 'numeric', {'numel', 2, 'increasing', 'positive', '<=', 100});
end

% Compute group edge - left & right
groupEdgeLeft  = (1:nGroup)' - 0.5 + GroupSpace / 2;
groupEdgeRight = (1:nGroup)' + 0.5 - GroupSpace / 2;

% Compute box width
boxWidth = (1 - (nCategory - 1) * CategorySpace) ./ nCategory * (groupEdgeRight(1) - groupEdgeLeft(1));

% Compute box edge - left & right
boxEdgeLeft  = arrayfun(@(x, y, z) x:z + CategorySpace:y, groupEdgeLeft, groupEdgeRight, boxWidth, "UniformOutput", false);
boxEdgeRight = arrayfun(@(x, y, z) x + z:z + CategorySpace:y + z, groupEdgeLeft, groupEdgeRight, boxWidth, "UniformOutput", false);

% Compute box edge - top & bottom
if strcmpi(BoxEdgeType, "se")
    boxEdgeLower = cellfun(@(x) mean(x, 1) - SE(x, 1), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1) + SE(x, 1), X, "UniformOutput", false);
elseif strcmpi(BoxEdgeType, "std")
    boxEdgeLower = cellfun(@(x) mean(x, 1) - std(x, [], 1), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1) + std(x, [], 1), X, "UniformOutput", false);
elseif isnumeric(BoxEdgeType) && numel(BoxEdgeType) == 2 && BoxEdgeType(2) > BoxEdgeType(1)
    boxEdgeLower = cellfun(@(x) prctile(x, BoxEdgeType(1), 1), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) prctile(x, BoxEdgeType(2), 1), X, "UniformOutput", false);
else
    error("[BoxEdgeType] should be 'SE', 'STD', or a 2-element percentile vector");
end

% Compute whisker
whiskerLower = cellfun(@(x) prctile(x, Whisker(1), 1), X, "UniformOutput", false);
whiskerUpper = cellfun(@(x) prctile(x, Whisker(2), 1), X, "UniformOutput", false);
idx = find(cellfun(@(x) strcmpi(x, "Width"), WhiskerCapParameters), 1);
if ~isempty(idx)
    whiskerCapWidth = WhiskerCapParameters{idx + 1} * boxWidth;
    WhiskerCapParameters(idx:idx + 1) = [];
end

% Colors
if isnumeric(Colors) % single color for all boxes
    Colors = arrayfun(@(x) repmat(validatecolor(Colors), x, 1), nCategory, "UniformOutput", false);
elseif iscell(Colors)
    Colors = cellfun(@(x) validatecolor(x, 'multiple'), Colors(:), "UniformOutput", false);

    % specifies colors for each category in each group
    if isequal(cellfun(@(x) size(x, 1), Colors), nCategory)
        
    else % specifies colors for each category by looping assignment
        Colors = mCell2mat(Colors);
        Colors = repmat(Colors, ceil(sum(nCategory) / size(Colors, 1)), 1);
        Colors = Colors(1:sum(nCategory), :);
        Colors = mat2cell(Colors, nCategory, size(Colors, 2));
    end

end

% Center lines
idx = find(cellfun(@(x) strcmpi(x, "Type"), CenterLineParameters), 1);
if ~isempty(idx)
    CenterLineType = CenterLineParameters{idx + 1};
    CenterLineParameters(idx:idx + 1) = [];
else
    CenterLineType = 'Mean';
end

% Boxplot
legendHandles = gobjects(1, max(nCategory));
legendLabels = cell(1, max(nCategory));
hold(ax, 'on');
for gIndex = 1:nGroup

    for cIndex = 1:nCategory(gIndex)
        left = boxEdgeLeft{gIndex}(cIndex);
        right = boxEdgeRight{gIndex}(cIndex);
        bottom = boxEdgeLower{gIndex}(cIndex);
        top = boxEdgeUpper{gIndex}(cIndex);
        boxCenter = (left + right) / 2;

        % plot individual data points
        if strcmpi(IndividualDataPoint, "show")
            idx = find(cellfun(@(x) strcmpi(x, "MarkerFaceColor"), SymbolParameters), 1);
            if ~isempty(idx) && strcmpi(SymbolParameters{idx + 1}, "auto")
                params = SymbolParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
            else
                params = SymbolParameters;
            end
            swarmchart(boxCenter * ones(numel(X{gIndex}(:, cIndex)), 1), X{gIndex}(:, cIndex), ...
                       "XJitterWidth", Jitter, params{:});
        end
        
        % plot box
        if gIndex == 1
            % set legends
            legendHandles(cIndex) = patch(ax, "XData", [left, right, right, left], ...
                                              "YData", [bottom, bottom, top, top], ...
                                              "EdgeColor", Colors{gIndex}(cIndex, :), ...
                                              BoxParameters{:});
            if ~isempty(CategoryLegends) && numel(CategoryLegends) >= cIndex
                legendLabels{cIndex} = CategoryLegends{cIndex};
            end
        else
            patch(ax, "XData", [left, right, right, left], ...
                      "YData", [bottom, bottom, top, top], ...
                      "EdgeColor", Colors{gIndex}(cIndex, :), ...
                      BoxParameters{:});
        end
        
        % plot center line
        if strcmpi(CenterLineType, 'Mean')
            yCenterLine = mean(X{gIndex}(:, cIndex), 1);
        elseif strcmpi(CenterLineType, 'Median')
            yCenterLine = median(X{gIndex}(:, cIndex), 1);
        else
            error("Invalid center line type");
        end
        idx = find(cellfun(@(x) strcmpi(x, "Color"), CenterLineParameters), 1);
        if ~isempty(idx) && strcmpi(CenterLineParameters{idx + 1}, "auto")
            params = CenterLineParameters;
            params{idx + 1} = Colors{gIndex}(cIndex, :);
        else
            params = CenterLineParameters;
        end
        line(ax, [left, right], [yCenterLine, yCenterLine], params{:});

        % plot whisker
        if ~isempty(Whisker)
            % whisker
            idx = find(cellfun(@(x) strcmpi(x, "Color"), WhiskerParameters), 1);
            if ~isempty(idx) && strcmpi(WhiskerParameters{idx + 1}, "auto")
                params = WhiskerParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
            else
                params = WhiskerParameters;
            end
            line(ax, [boxCenter, boxCenter], [bottom, whiskerLower{gIndex}(cIndex)], params{:});
            line(ax, [boxCenter, boxCenter], [top,    whiskerUpper{gIndex}(cIndex)], params{:});
            
            % whisker cap
            idx = find(cellfun(@(x) strcmpi(x, "Color"), WhiskerCapParameters), 1);
            if ~isempty(idx) && strcmpi(WhiskerCapParameters{idx + 1}, "auto")
                params = WhiskerCapParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
            else
                params = WhiskerCapParameters;
            end
            line(ax, [boxCenter - whiskerCapWidth(gIndex) / 2, boxCenter + whiskerCapWidth(gIndex) / 2], ...
                     [whiskerLower{gIndex}(cIndex), whiskerLower{gIndex}(cIndex)], params{:});
            line(ax, [boxCenter - whiskerCapWidth(gIndex) / 2, boxCenter + whiskerCapWidth(gIndex) / 2], ...
                     [whiskerUpper{gIndex}(cIndex), whiskerUpper{gIndex}(cIndex)], params{:});
        end

        % plot group lines
        if GroupLines && gIndex > 1
            xline(gIndex - 0.5);
        end

    end

end

if ~isempty(CategoryLegends)
    validHandles = isgraphics(legendHandles);
    legend(ax, legendHandles(validHandles), legendLabels(validHandles), ...
           'Location', 'best', 'AutoUpdate', 'off');
end

setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels)

if nargout == 1
    varargout{1} = ax;
end

return;
end

function A = getOrCellParameters(C, default)
    params0 = cellstr(default(1:2:end));
    params = cellstr(C(1:2:end));
    A = C(:)';

    for index = 1:numel(params0)
        if ~ismember(params0(index), params)
            A = [A, params0(index), default(2 * index)];
        end
    end

    return;
end

function setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels)
    % label positions
    groupCenters = cellfun(@(l, r) mean([l(:), r(:)], 2), boxEdgeLeft, boxEdgeRight, 'UniformOutput', false);
    categoryCenters = cellfun(@(l, r) (l + r) / 2, boxEdgeLeft, boxEdgeRight, 'UniformOutput', false);

    % remove current xticklabels
    set(ax, 'XTickLabel', [], 'XTick', cat(2, categoryCenters{:}));
    
    % current axes positions
    ylims = ylim(ax);
    labelYPos = ylims(1) - 0.01 * diff(ylims);
    
    % group labels (secondary labels)
    if ~all(cellfun(@isempty, GroupLabels)) && numel(GroupLabels) == nGroup
        for g = 1:nGroup
            text(ax, mean(groupCenters{g}), labelYPos - 0.01 * diff(ylims), GroupLabels{g}, ...
                 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'top', ...
                 'FontWeight', 'bold', ...
                 'FontSize', get(ax, 'FontSize'));
        end
    end
    
    % category labels (primary labels)
    if ~all(cellfun(@isempty, CategoryLabels)) && numel(CategoryLabels) >= max(nCategory)
        for g = 1:nGroup
            for c = 1:nCategory(g)
                text(ax, categoryCenters{g}(c), labelYPos, CategoryLabels{c}, ...
                     'HorizontalAlignment', 'center', ...
                     'VerticalAlignment', 'top', ...
                     'FontSize', get(ax, 'FontSize'));
            end
        end
    end

    return;
end