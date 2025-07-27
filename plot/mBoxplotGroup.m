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
%     'GroupLegends'    - Cell array of strings for legend entries (per group)
%     'GroupSpace'      - Spacing between groups (default: 0.1)
%     'CategorySpace'   - Spacing between categories within groups (default: 0.4)
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
%     - For different category numbers across groups, use NAN values to fill the columns
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
mIp.addParameter("GroupLegends", '');
mIp.addParameter("GroupSpace", 0.1, @(x) validateattributes(x, 'numeric', {'scalar'}));
mIp.addParameter("GroupLines", false, @(x) validateattributes(x, 'logical', {'scalar'}));
mIp.addParameter("CategoryLabels", '');
mIp.addParameter("CategorySpace", 0.4, @(x) validateattributes(x, 'numeric', {'scalar'}));
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
GroupLegends = cellstr(mIp.Results.GroupLegends);
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
nCategory = cellfun(@(x) size(x, 2), X); % category number under each group
if ~all(nCategory == nCategory(1))
    error("All groups should contain the same categories. If not, please fill NAN values for that column.");
end
nCategory = nCategory(1);
nGroup = numel(X);

if ~isempty(Whisker)
    validateattributes(Whisker, 'numeric', {'numel', 2, 'increasing', 'positive', '<=', 100});
end

% Compute group edge (left & right) for each group
groupEdgeLeft  = (1:nCategory)' - 0.5 + CategorySpace / 2;
groupEdgeRight = (1:nCategory)' + 0.5 - CategorySpace / 2;

% Compute box width
boxWidth = (1 - (nGroup - 1) * GroupSpace) / nGroup * (groupEdgeRight(1) - groupEdgeLeft(1));

% Compute box edge (left & right) for each category
boxEdgeLeft  = arrayfun(@(x, y) x:boxWidth + GroupSpace * (groupEdgeRight(1) - groupEdgeLeft(1)):y, groupEdgeLeft, groupEdgeRight, "UniformOutput", false);
boxEdgeRight = arrayfun(@(x, y) x + boxWidth:boxWidth + GroupSpace * (groupEdgeRight(1) - groupEdgeLeft(1)):y + boxWidth, groupEdgeLeft, groupEdgeRight, "UniformOutput", false);
boxEdgeLeft  = cat(1, boxEdgeLeft {:}); % category-by-group
boxEdgeRight = cat(1, boxEdgeRight{:}); % category-by-group

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
boxEdgeLower = cat(1, boxEdgeLower{:})'; % category-by-group
boxEdgeUpper = cat(1, boxEdgeUpper{:})'; % category-by-group

% Compute whisker
whiskerLower = cellfun(@(x) prctile(x, Whisker(1), 1), X, "UniformOutput", false);
whiskerUpper = cellfun(@(x) prctile(x, Whisker(2), 1), X, "UniformOutput", false);
whiskerLower = cat(1, whiskerLower{:})'; % category-by-group
whiskerUpper = cat(1, whiskerUpper{:})'; % category-by-group
idx = find(cellfun(@(x) strcmpi(x, "Width"), WhiskerCapParameters), 1);
if ~isempty(idx)
    whiskerCapWidth = WhiskerCapParameters{idx + 1} * boxWidth;
    WhiskerCapParameters(idx:idx + 1) = [];
end

% Colors
if isnumeric(Colors) % single color for all boxes
    Colors = repmat(validatecolor(Colors), nCategory, 1);
elseif iscell(Colors)
    if numel(Colors) ~= nGroup
        error("The number of colors should be equal to the number of groups.");
    end
    Colors = cellfun(@(x) validatecolor(x, 'multiple'), Colors(:), "UniformOutput", false);

    % specifies colors for each category in each group
    nColor = cellfun(@(x) size(x, 1), Colors);
    for cIndex = 1:nGroup
        if nColor == 1
            Colors{cIndex} = repmat(Colors{cIndex}, nCategory, 1);
        elseif nColor(cIndex) ~= nCategory
            error("The number of colors should be equal to the number of categories.");
        end
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
legendHandles = gobjects(1, nGroup);
legendLabels = cell(1, nGroup);
hold(ax, 'on');
for cIndex = 1:nCategory

    for gIndex = 1:nGroup
        left = boxEdgeLeft(cIndex, gIndex);
        right = boxEdgeRight(cIndex, gIndex);
        bottom = boxEdgeLower(cIndex, gIndex);
        top = boxEdgeUpper(cIndex, gIndex);
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
        if cIndex == 1
            % set legends
            legendHandles(gIndex) = patch(ax, "XData", [left, right, right, left], ...
                                              "YData", [bottom, bottom, top, top], ...
                                              "EdgeColor", Colors{gIndex}(cIndex, :), ...
                                              BoxParameters{:});
            if ~isempty(GroupLegends) && numel(GroupLegends) >= gIndex
                legendLabels{gIndex} = GroupLegends{gIndex};
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
            line(ax, [boxCenter, boxCenter], [bottom, whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [boxCenter, boxCenter], [top,    whiskerUpper(cIndex, gIndex)], params{:});
            
            % whisker cap
            idx = find(cellfun(@(x) strcmpi(x, "Color"), WhiskerCapParameters), 1);
            if ~isempty(idx) && strcmpi(WhiskerCapParameters{idx + 1}, "auto")
                params = WhiskerCapParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
            else
                params = WhiskerCapParameters;
            end
            line(ax, [boxCenter - whiskerCapWidth / 2, boxCenter + whiskerCapWidth / 2], ...
                     [whiskerLower(cIndex, gIndex), whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [boxCenter - whiskerCapWidth / 2, boxCenter + whiskerCapWidth / 2], ...
                     [whiskerUpper(cIndex, gIndex), whiskerUpper(cIndex, gIndex)], params{:});
        end

        % plot group lines
        if GroupLines && cIndex > 1
            xline(cIndex - 0.5);
        end

    end

end

if ~all(cellfun(@isempty, GroupLegends))
    validHandles = isgraphics(legendHandles);
    legend(ax, legendHandles(validHandles), legendLabels(validHandles), ...
           'Location', 'best', 'AutoUpdate', 'off');
end

xlim(ax, [0.5, nCategory + 0.5]);
drawnow;
labelAx = setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels);

if nargout >= 1
    varargout{1} = ax;
end

if nargout == 2
    varargout{2} = labelAx;
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

function labelAx = setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels)
    % label positions
    categoryCenters = (boxEdgeLeft + boxEdgeRight) / 2; % category-by-group

    % remove current xticklabels
    set(ax, 'XTickLabel', [], 'XTick', sort(categoryCenters(:), "ascend"));

    % current axes positions
    pos = get(ax, "Position");
    labelAx = axes("Position", [pos(1), pos(2) - pos(4) * 0.15, pos(3), pos(4) * 0.15], "Visible", "off");

    % label position
    labelPosY_group = 0.8;
    if ~all(cellfun(@isempty, CategoryLabels)) && ~all(cellfun(@isempty, GroupLabels))
        labelPosY_category = 0.5;
    elseif ~all(cellfun(@isempty, CategoryLabels)) && all(cellfun(@isempty, GroupLabels))
        labelPosY_category = 0.8;
    end

    % group labels (primary labels)
    if ~all(cellfun(@isempty, GroupLabels)) && numel(GroupLabels) == nGroup
        for gIndex = 1:nGroup
            for cIndex = 1:nCategory
                text(labelAx, categoryCenters(cIndex, gIndex), labelPosY_group, GroupLabels{gIndex}, ...
                     'HorizontalAlignment', 'center', ...
                     'VerticalAlignment', 'middle', ...
                     "FontName", "Arial", ...
                     'FontSize', get(ax, 'FontSize'));
            end
        end
    end
    
    % category labels (secondary labels)
    if ~all(cellfun(@isempty, CategoryLabels)) && numel(CategoryLabels) == nCategory
        for cIndex = 1:nCategory
            text(labelAx, cIndex, labelPosY_category, CategoryLabels{cIndex}, ...
                 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'middle', ...
                 "FontName", "Arial", ...
                 'FontWeight', 'bold', ...
                 'FontSize', get(ax, 'FontSize'));
        end
    end

    xlim(labelAx, [0.5, nCategory + 0.5]);
    ylim(labelAx, [0, 1]);
    return;
end