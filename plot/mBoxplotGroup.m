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
%     'Notch'           - Notch option, 'on' or 'off' (defualt: 'off')
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
%     data = {randn(50,3), randn(60,3)}; % 2 groups, 3 categories each
%     figure;
%     mBoxplotGroup(data, ...
%         'GroupLabels', {'Control','Treatment'}, ...
%         'CategoryLabels', {'Method A','Method B','Method C'}, ...
%         'Whisker', [5 95], ...
%         'Colors', lines(2), ...
%         'Notch', 'on');
%
%   NOTES:
%     - For different category numbers across groups, use NAN values to fill the columns
%     - For box edges: 'SE' uses mean±SE, 'STD' uses mean±STD, or specify percentiles
%     - Category legends only shown if 'CategoryLegends' specified
%     - Default point size is 36 (in points^2)
%
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
defaultCenterLineParameters = {"Type", "Median", ...
                               "LineStyle", "-", ...
                               "LineWidth", "auto", ...
                               "Color", "auto"};
defaultWhiskerParameters = {"LineStyle", "-", ...
                            "LineWidth", "auto", ...
                            "Color", "auto"};
defaultWhiskerCapParameters = {"LineStyle", "-", ...
                               "LineWidth", "auto", ...
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
mIp.addParameter("BoxEdgeType", [25, 75]);
mIp.addParameter("Whisker", [5, 95]);
mIp.addParameter("Notch", "off", @(x) any(validatestring(x, {'on', 'off'})));
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
Notch = mIp.Results.Notch;
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

BoxLineWidth = getNameValue(BoxParameters, "LineWidth");
if strcmpi(getNameValue(CenterLineParameters, "LineWidth"), "auto")
    CenterLineParameters = changeNameValue(CenterLineParameters, "LineWidth", BoxLineWidth);
end
if strcmpi(getNameValue(WhiskerParameters, "LineWidth"), "auto")
    WhiskerParameters = changeNameValue(WhiskerParameters, "LineWidth", BoxLineWidth);
end
if strcmpi(getNameValue(WhiskerCapParameters, "LineWidth"), "auto")
    WhiskerCapParameters = changeNameValue(WhiskerCapParameters, "LineWidth", BoxLineWidth);
end

% Compute quartiles and sample size for notch
q1 = cellfun(@(x) prctile(x, 25, 1), X, 'UniformOutput', false);
q2 = cellfun(@(x) prctile(x, 50, 1), X, 'UniformOutput', false); % median
q3 = cellfun(@(x) prctile(x, 75, 1), X, 'UniformOutput', false);
nNonNaN = cellfun(@(x) sum(~isnan(x), 1), X, 'UniformOutput', false); % non-NaN counts

q1 = cat(1, q1{:})';      % category-by-group
q2 = cat(1, q2{:})';
q3 = cat(1, q3{:})';
nNonNaN = cat(1, nNonNaN{:})';

% Notch bounds
notchLower = q2 - 1.57 * (q3 - q1) ./ sqrt(nNonNaN);
notchUpper = q2 + 1.57 * (q3 - q1) ./ sqrt(nNonNaN);

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
    boxEdgeLower = cellfun(@(x) mean(x, 1, "omitnan") - SE(x, 1, "omitnan"), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1, "omitnan") + SE(x, 1, "omitnan"), X, "UniformOutput", false);
elseif strcmpi(BoxEdgeType, "std")
    boxEdgeLower = cellfun(@(x) mean(x, 1, "omitnan") - std(x, [], 1, "omitnan"), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1, "omitnan") + std(x, [], 1, "omitnan"), X, "UniformOutput", false);
elseif isnumeric(BoxEdgeType) && numel(BoxEdgeType) == 2 && BoxEdgeType(2) > BoxEdgeType(1)
    boxEdgeLower = cellfun(@(x) prctile(x, BoxEdgeType(1), 1), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) prctile(x, BoxEdgeType(2), 1), X, "UniformOutput", false);
else
    error("[BoxEdgeType] should be 'SE', 'STD', or a 2-element percentile vector (default=[25,75])");
end
boxEdgeLower = cat(1, boxEdgeLower{:})'; % category-by-group
boxEdgeUpper = cat(1, boxEdgeUpper{:})'; % category-by-group

% Compute whisker
whiskerLower = cellfun(@(x) prctile(x, Whisker(1), 1), X, "UniformOutput", false);
whiskerUpper = cellfun(@(x) prctile(x, Whisker(2), 1), X, "UniformOutput", false);
whiskerLower = cat(1, whiskerLower{:})'; % category-by-group
whiskerUpper = cat(1, whiskerUpper{:})'; % category-by-group
WhiskerCapWidth = getNameValue(WhiskerCapParameters, "Width") * boxWidth;
WhiskerCapParameters = removeNameValue(WhiskerCapParameters, "Width");
WhiskerColor = getNameValue(WhiskerParameters, "Color");
WhiskerCapColor = getNameValue(WhiskerCapParameters, "Color");

% Colors
if isnumeric(Colors) % single color for all boxes
    if size(Colors, 1) == 1
        Colors = repmat({repmat(validatecolor(Colors), nCategory, 1)}, nGroup, 1);
    elseif size(Colors, 1) == nGroup
        Colors = rowFcn(@(x) repmat(validatecolor(x), nCategory, 1), Colors, "UniformOutput", false);
    elseif size(Colors, 1) == nCategory * nGroup
        Colors = mat2cell(validatecolor(Colors, 'multiple'), repmat(nCategory, nGroup, 1), 3);
        warning("Group legends may not work if colors are specified for each category");
    else
        error("The number of colors should either be 1, group number, or category number*group number");
    end
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
CenterLineType = getNameValue(CenterLineParameters, "Type");
if isempty(CenterLineType)
    CenterLineType = 'Mean';
end
CenterLineColor = getNameValue(CenterLineParameters, "Color");
CenterLineParameters = removeNameValue(CenterLineParameters, "Type");

% Boxplot
legendHandles = gobjects(1, nGroup);
legendLabels = cell(1, nGroup);
hold(ax, 'on');
for cIndex = 1:nCategory

    for gIndex = 1:nGroup
        left = boxEdgeLeft(cIndex, gIndex);
        right = boxEdgeRight(cIndex, gIndex);
        mid = (left + right) / 2;

        % plot individual data points
        if strcmpi(IndividualDataPoint, "show")
            SymbolMarkerFaceColor = getNameValue(SymbolParameters, "MarkerFaceColor");

            if strcmpi(SymbolMarkerFaceColor, "auto")
                params = changeNameValue(SymbolParameters, "MarkerFaceColor", Colors{gIndex}(cIndex, :));
            else
                params = SymbolParameters;
            end

            swarmchart(mid * ones(numel(X{gIndex}(:, cIndex)), 1), X{gIndex}(:, cIndex), ...
                       "XJitterWidth", Jitter, params{:});
        end
        
        % plot box
        if strcmpi(Notch, "on")
            notchWidth = boxWidth * 0.3;
            top = q3(cIndex, gIndex);
            bottom = q1(cIndex, gIndex);

            xBox = [left, left, ...
                    mid - notchWidth, ...
                    left, left, ...
                    right, right, ...
                    mid + notchWidth, ...
                    right, right];
            
            yBox = [top, notchUpper(cIndex, gIndex), ...
                    q2(cIndex, gIndex), ...
                    notchLower(cIndex, gIndex), bottom, ...
                    bottom, notchLower(cIndex, gIndex), ...
                    q2(cIndex, gIndex), ...
                    notchUpper(cIndex, gIndex), top];

            CenterLineType = 'Median';
            centerLineX = [mid - notchWidth, mid + notchWidth];
        else
            bottom = boxEdgeLower(cIndex, gIndex);
            top = boxEdgeUpper(cIndex, gIndex);

            xBox = [left, right, right, left];
            yBox = [top, top, bottom, bottom];
            centerLineX = [left, right];
        end

        if cIndex == 1
            % set legends
            legendHandles(gIndex) = patch(ax, "XData", xBox, ...
                                              "YData", yBox, ...
                                              "EdgeColor", Colors{gIndex}(cIndex, :), ...
                                              BoxParameters{:});
            if ~isempty(GroupLegends) && numel(GroupLegends) >= gIndex
                legendLabels{gIndex} = GroupLegends{gIndex};
            end
        else
            patch(ax, "XData", xBox, ...
                      "YData", yBox, ...
                      "EdgeColor", Colors{gIndex}(cIndex, :), ...
                      BoxParameters{:});
        end
        
        % plot center line
        if strcmpi(CenterLineType, 'Mean')
            yCenterLine = mean(X{gIndex}(:, cIndex), 1, "omitnan");
        elseif strcmpi(CenterLineType, 'Median')
            yCenterLine = median(X{gIndex}(:, cIndex), 1, "omitnan");
        else
            error("Invalid center line type");
        end

        if strcmpi(CenterLineColor, "auto")
            params = changeNameValue(CenterLineParameters, "Color", Colors{gIndex}(cIndex, :));
        else
            params = CenterLineParameters;
        end
        line(ax, centerLineX, [yCenterLine, yCenterLine], params{:});

        % plot whisker
        if ~isempty(Whisker)
            % whisker
            if strcmpi(WhiskerColor, "auto")
                params = changeNameValue(WhiskerParameters, "Color", Colors{gIndex}(cIndex, :));
            else
                params = WhiskerParameters;
            end
            line(ax, [mid, mid], [bottom, whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [mid, mid], [top,    whiskerUpper(cIndex, gIndex)], params{:});
            
            % whisker cap
            if strcmpi(WhiskerCapColor, "auto")
                params = changeNameValue(WhiskerCapParameters, "Color", Colors{gIndex}(cIndex, :));
            else
                params = WhiskerCapParameters;
            end
            line(ax, [mid - WhiskerCapWidth / 2, mid + WhiskerCapWidth / 2], ...
                     [whiskerLower(cIndex, gIndex), whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [mid - WhiskerCapWidth / 2, mid + WhiskerCapWidth / 2], ...
                     [whiskerUpper(cIndex, gIndex), whiskerUpper(cIndex, gIndex)], params{:});
        end

        % plot group lines
        if GroupLines && cIndex > 1
            xline(cIndex - 0.5);
        end

    end

end

xlim(ax, [0.5, nCategory + 0.5]);
drawnow;
setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels);

if ~all(cellfun(@isempty, GroupLegends))
    validHandles = isgraphics(legendHandles);
    legend(ax, legendHandles(validHandles), legendLabels(validHandles), 'Location', 'best', 'AutoUpdate', 'off');
end

if nargout >= 1
    varargout{1} = ax;
end

% redirect gca to ax
axes(ax);
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

function val = getNameValue(C, key)
    if mod(numel(C), 2) ~= 0
        error("Name-values should be paired");
    end

    map = containers.Map(cellstr(C(1:2:end)), C(2:2:end));

    if isKey(map, key)
        val = map(key);
    else
        val = [];
    end

    return;
end

function C = changeNameValue(C, key, val)
    if mod(numel(C), 2) ~= 0
        error("Name-values should be paired");
    end

    map = containers.Map(cellstr(C(1:2:end)), C(2:2:end));

    if isKey(map, key)
        map(key) = val;
    else
        error(strcat(key, " is not a parameter"));
    end
    
    C = [map.keys; map.values];
    C = C(:)';
    return;
end

function C = removeNameValue(C, key)
    if mod(numel(C), 2) ~= 0
        error("Name-values should be paired");
    end

    map = containers.Map(cellstr(C(1:2:end)), C(2:2:end));

    if isKey(map, key)
        remove(map, key);
    end

    C = [map.keys; map.values];
    C = C(:)';
    return;
end

function setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels)
    hasGroupLabels = ~all(cellfun(@isempty, GroupLabels));
    hasCategoryLabels = ~all(cellfun(@isempty, CategoryLabels));

    % label positions
    categoryCenters = (boxEdgeLeft + boxEdgeRight) / 2; % category-by-group

    if hasGroupLabels && ~hasCategoryLabels
        set(ax, 'XTick', sort(categoryCenters(:), "ascend"), ...
                'XTickLabel', repmat(GroupLabels(:)', 1, nCategory));
    elseif ~hasGroupLabels && hasCategoryLabels
        set(ax, 'XTick', 1:nCategory, ...
                'XTickLabel', CategoryLabels);
    elseif hasGroupLabels && hasCategoryLabels
        % remove current xticklabels
        set(ax, 'XTick', sort(categoryCenters(:), "ascend"), 'XTickLabel', []);

        % current axes positions
        pos = get(ax, "Position");
        labelAx = axes("Position", [pos(1), pos(2) - pos(4) * 0.15, pos(3), pos(4) * 0.15], "Visible", "off");

        % label position
        labelPosY_group = 0.8;
        labelPosY_category = 0.5;

        % group labels (primary labels)
        for gIndex = 1:nGroup
            for cIndex = 1:nCategory
                text(labelAx, categoryCenters(cIndex, gIndex), labelPosY_group, GroupLabels{gIndex}, ...
                     'HorizontalAlignment', 'center', ...
                     'VerticalAlignment', 'middle', ...
                     "FontName", "Arial", ...
                     'FontSize', get(ax, 'FontSize'));
            end
        end

        % category labels (secondary labels)
        for cIndex = 1:nCategory
            text(labelAx, cIndex, labelPosY_category, CategoryLabels{cIndex}, ...
                 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'middle', ...
                 "FontName", "Arial", ...
                 'FontWeight', 'bold', ...
                 'FontSize', get(ax, 'FontSize'));
        end

        xlim(labelAx, [0.5, nCategory + 0.5]);
        ylim(labelAx, [0, 1]);
    else
        set(ax, 'XTick', [], 'XTickLabel', []);
    end

    return;
end