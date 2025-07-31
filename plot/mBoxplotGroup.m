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
%     'Positions'            - X-positions of category centers (default: 1:nCategory)
%     'BoxEdgeType'          - Box edge calculation: 'SE', 'STD', or [low,high] percentiles
%     'Notch'                - Notch option, 'on' or 'off' (defualt: 'off')
%     'Whisker'              - Maximum whisker length W (see BOXPLOT) or 
%                              whisker percentiles [low,high] (default: [10,90])
%     'Colors'               - Color specification (single color, cell array, or colormap)
%     'BoxParameters'        - Cell array of patch properties for boxes
%     'CenterLineParameters' - Properties for center lines (mean/median)
%     'WhiskerParameters'    - Properties for whisker lines
%     'WhiskerCapParameters' - Properties for whisker caps 
%
%   DATA POINTS:
%     'IndividualDataPoint' - 'show' or 'hide' individual points (default: 'show')
%     'SymbolParameters'    - Properties for individual data points
%     'Jitter'              - Amount of horizontal jitter (default: 0.1)
%     'Outlier'             - 'show' or 'hide' outliers (default: 'hide')
%     'OutlierParameters'   - Properties for outliers
%
%   EXAMPLE:
%     data = {randn(50,3), randn(60,3)}; % 2 groups, 3 categories each
%     figure;
%     mBoxplotGroup(data, ...
%                   'GroupLabels', {'Control', 'Treatment'}, ...
%                   'CategoryLabels', {'Method A', 'Method B', 'Method C'}, ...
%                   'Whisker', [5, 95], ...
%                   'Colors', lines(2), ...
%                   'Notch', 'on', ...
%                   'BoxParameters', {'FaceColor', 'auto'});
%
%   NOTES:
%     - For different category numbers across groups, use NAN values to fill the columns
%     - For box edges: 'SE' uses mean±SE, 'STD' uses mean±STD, or specify percentiles
%     - Category legends only shown if 'CategoryLegends' specified
%     - Default point size is 36 (in points^2)
%     - Default line widths of center line, whisker, and whisker cap are 'auto', 
%       which implements from [BoxParameters].
%     - Default colors of center line, whisker, and whisker cap are 'auto',
%       which uses [Colors] (of box edges).
%     - To set the font size of group/category labels, please set(ax, "FontSize", val) 
%       before using `mBoxplotGroup`.
%
% Copyright (c) 2025 HX Xu. All rights reserved.
% 

if isgraphics(varargin{1}(1), "axes")
    ax = varargin{1}(1);
    varargin = varargin(2:end);
else
    ax = gca;
end

defaultBoxParameters = {"LineStyle", "-", ...
                        "LineWidth", 0.5, ...
                        "FaceColor", "none", ...
                        "FaceAlpha", 0.5};
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
defaultOutlierParameters = {"Marker", "+", ...
                            "MarkerEdgeColor", "auto", ...
                            "MarkerFaceColor", "auto", ...
                            "SizeData", 36, ...
                            "LineWidth", 0.5};

mIp = inputParser;
mIp.addRequired("ax", @(x) isgraphics(x, "axes"));
mIp.addRequired("X", @(x) validateattributes(x, 'cell', {'vector'}));
mIp.addParameter("Positions", [], @(x) validateattributes(x, 'numeric', {'vector', 'increasing'}));
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
mIp.addParameter("BoxParameters", defaultBoxParameters, @iscell);
mIp.addParameter("CenterLineParameters", defaultCenterLineParameters, @iscell);
mIp.addParameter("WhiskerParameters", defaultWhiskerParameters, @iscell);
mIp.addParameter("WhiskerCapParameters", defaultWhiskerCapParameters, @iscell);
mIp.addParameter("IndividualDataPoint", "show", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.addParameter("SymbolParameters", defaultSymbolParameters, @iscell);
mIp.addParameter("Jitter", 0.1, @(x) validateattributes(x, 'numeric', {'scalar'}));
mIp.addParameter("Outlier", "hide", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.addParameter("OutlierParameters", defaultOutlierParameters, @iscell);

mIp.parse(ax, varargin{:});

X = mIp.Results.X;
positions = mIp.Results.Positions;
groupLabels = cellstr(mIp.Results.GroupLabels);
groupSpace = mIp.Results.GroupSpace;
groupLines = mIp.Results.GroupLines;
categoryLabels = cellstr(mIp.Results.CategoryLabels);
groupLegends = cellstr(mIp.Results.GroupLegends);
categorySpace = mIp.Results.CategorySpace;
colors = mIp.Results.Colors;
boxEdgeType = mIp.Results.BoxEdgeType;
notchOpt = mIp.Results.Notch;
boxParameters = getOrCellParameters(mIp.Results.BoxParameters, defaultBoxParameters);
centerLineParameters = getOrCellParameters(mIp.Results.CenterLineParameters, defaultCenterLineParameters);
whisker = mIp.Results.Whisker;
whiskerParameters = getOrCellParameters(mIp.Results.WhiskerParameters, defaultWhiskerParameters);
whiskerCapParameters = getOrCellParameters(mIp.Results.WhiskerCapParameters, defaultWhiskerCapParameters);
individualDataPoint = mIp.Results.IndividualDataPoint;
symbolParameters = getOrCellParameters(mIp.Results.SymbolParameters, defaultSymbolParameters);
jitterWidth = mIp.Results.Jitter;
outlierOpt = mIp.Results.Outlier;
outlierParameters = getOrCellParameters(mIp.Results.OutlierParameters, defaultOutlierParameters);

% Validate
X = X(:);
nCategory = cellfun(@(x) size(x, 2), X); % category number under each group
if ~all(nCategory == nCategory(1))
    error("All groups should contain the same categories. If not, please fill NAN values for that column.");
end
nCategory = nCategory(1);
nGroup = numel(X);

if ~isempty(whisker)
    if isscalar(whisker)
        validateattributes(whisker, 'numeric', {'positive'});
    elseif numel(whisker) == 2
        validateattributes(whisker, 'numeric', {'numel', 2, 'increasing', 'positive', '<=', 100});
    else
        error("The input whisker percentiles should be an increasing 2-element vector (for percentile) or a scalar (for IQR).");
    end
end

boxLineWidth = getNameValue(boxParameters, "LineWidth");
if strcmpi(getNameValue(centerLineParameters, "LineWidth"), "auto")
    centerLineParameters = changeNameValue(centerLineParameters, "LineWidth", boxLineWidth);
end
if strcmpi(getNameValue(whiskerParameters, "LineWidth"), "auto")
    whiskerParameters = changeNameValue(whiskerParameters, "LineWidth", boxLineWidth);
end
if strcmpi(getNameValue(whiskerCapParameters, "LineWidth"), "auto")
    whiskerCapParameters = changeNameValue(whiskerCapParameters, "LineWidth", boxLineWidth);
end

boxFaceColor = getNameValue(boxParameters, "FaceColor");
symbolMarkerFaceColor = getNameValue(symbolParameters, "MarkerFaceColor");
outlierMarkerFaceColor = getNameValue(outlierParameters, "MarkerFaceColor");
outlierMarkerEdgeColor = getNameValue(outlierParameters, "MarkerEdgeColor");

% Compute quartiles and sample size for notch
q1 = cellfun(@(x) prctile(x, 25, 1), X, 'UniformOutput', false);
q2 = cellfun(@(x) prctile(x, 50, 1), X, 'UniformOutput', false); % median
q3 = cellfun(@(x) prctile(x, 75, 1), X, 'UniformOutput', false);
nNonNaN = cellfun(@(x) sum(~isnan(x), 1), X, 'UniformOutput', false); % non-NaN counts

q1 = cat(1, q1{:})'; % category-by-group
q2 = cat(1, q2{:})'; % category-by-group
q3 = cat(1, q3{:})'; % category-by-group
iqr = q3 - q1; % category-by-group
nNonNaN = cat(1, nNonNaN{:})';

% Notch bounds
notchLower = q2 - 1.57 * (q3 - q1) ./ sqrt(nNonNaN);
notchUpper = q2 + 1.57 * (q3 - q1) ./ sqrt(nNonNaN);

% Compute group edge (left & right) for each group
if isempty(positions)
    positions = (1:nCategory)';
else
    positions = positions(:);
    if numel(positions) ~= nCategory
        error("The number of Positions should be equal to the number of categories.");
    end
end
categoryEdgeLeft = positions - min(diff(positions));
categoryWidthHalf = min(diff(positions)) * (1 - categorySpace) / 2;
groupEdgeLeft  = positions - categoryWidthHalf;
groupEdgeRight = positions + categoryWidthHalf;

% Compute box width
boxWidth = (1 - (nGroup - 1) * groupSpace) / nGroup * categoryWidthHalf * 2;

% Compute box edge (left & right) for each category
boxEdgeLeft  = arrayfun(@(x, y) x:boxWidth + groupSpace * categoryWidthHalf * 2:y, groupEdgeLeft, groupEdgeRight, "UniformOutput", false);
boxEdgeRight = arrayfun(@(x, y) x + boxWidth:boxWidth + groupSpace * categoryWidthHalf * 2:y + boxWidth, groupEdgeLeft, groupEdgeRight, "UniformOutput", false);
boxEdgeLeft  = cat(1, boxEdgeLeft {:}); % category-by-group
boxEdgeRight = cat(1, boxEdgeRight{:}); % category-by-group

% Compute box edge - top & bottom
if strcmpi(boxEdgeType, "se")
    boxEdgeLower = cellfun(@(x) mean(x, 1, "omitnan") - SE(x, 1, "omitnan"), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1, "omitnan") + SE(x, 1, "omitnan"), X, "UniformOutput", false);
elseif strcmpi(boxEdgeType, "std")
    boxEdgeLower = cellfun(@(x) mean(x, 1, "omitnan") - std(x, [], 1, "omitnan"), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) mean(x, 1, "omitnan") + std(x, [], 1, "omitnan"), X, "UniformOutput", false);
elseif isnumeric(boxEdgeType) && numel(boxEdgeType) == 2 && boxEdgeType(2) > boxEdgeType(1)
    boxEdgeLower = cellfun(@(x) prctile(x, boxEdgeType(1), 1), X, "UniformOutput", false);
    boxEdgeUpper = cellfun(@(x) prctile(x, boxEdgeType(2), 1), X, "UniformOutput", false);
else
    error("[BoxEdgeType] should be 'SE', 'STD', or a 2-element percentile vector (default=[25,75])");
end
boxEdgeLower = cat(1, boxEdgeLower{:})'; % category-by-group
boxEdgeUpper = cat(1, boxEdgeUpper{:})'; % category-by-group

% Compute whisker
if isscalar(whisker) % whisker length * IQR
    whiskerLower = q1 - whisker * iqr;  % category-by-group
    whiskerUpper = q3 + whisker * iqr;  % category-by-group
elseif numel(whisker) == 2 % percentile
    whiskerLower = cellfun(@(x) prctile(x, whisker(1), 1), X, "UniformOutput", false);
    whiskerUpper = cellfun(@(x) prctile(x, whisker(2), 1), X, "UniformOutput", false);
    whiskerLower = cat(1, whiskerLower{:})'; % category-by-group
    whiskerUpper = cat(1, whiskerUpper{:})'; % category-by-group
else % empty
    % do not show whisker
end
whiskerCapWidth = getNameValue(whiskerCapParameters, "Width") * boxWidth;
whiskerCapParameters = removeNameValue(whiskerCapParameters, "Width");
whiskerColor = getNameValue(whiskerParameters, "Color");
whiskerCapColor = getNameValue(whiskerCapParameters, "Color");

% Compute outliers
if strcmpi(outlierOpt, "show")
    outliers = cell(nCategory, nGroup);
    for cIndex = 1:nCategory
        for gIndex = 1:nGroup
            idx = X{gIndex}(:, cIndex) < whiskerLower(cIndex, gIndex) | X{gIndex}(:, cIndex) > whiskerUpper(cIndex, gIndex);
            outliers{cIndex, gIndex} = X{gIndex}(idx, cIndex);
        end
    end
end

% Colors
if isnumeric(colors) % single color for all boxes
    if size(colors, 1) == 1
        colors = repmat({repmat(validatecolor(colors), nCategory, 1)}, nGroup, 1);
    elseif size(colors, 1) == nGroup
        colors = rowFcn(@(x) repmat(validatecolor(x), nCategory, 1), colors, "UniformOutput", false);
    elseif size(colors, 1) == nCategory * nGroup
        colors = mat2cell(validatecolor(colors, 'multiple'), repmat(nCategory, nGroup, 1), 3);
        warning("Group legends may not work if colors are specified for each category");
    else
        error("The number of colors should either be 1, group number, or category number*group number");
    end
elseif iscell(colors)
    if numel(colors) ~= nGroup
        error("The number of colors should be equal to the number of groups.");
    end
    colors = cellfun(@(x) validatecolor(x, 'multiple'), colors(:), "UniformOutput", false);

    % specifies colors for each category in each group
    nColor = cellfun(@(x) size(x, 1), colors);
    for cIndex = 1:nGroup
        if nColor == 1
            colors{cIndex} = repmat(colors{cIndex}, nCategory, 1);
        elseif nColor(cIndex) ~= nCategory
            error("The number of colors should be equal to the number of categories.");
        end
    end

end

% Center lines
CenterLineType = getNameValue(centerLineParameters, "Type");
if isempty(CenterLineType)
    CenterLineType = 'Mean';
end
CenterLineColor = getNameValue(centerLineParameters, "Color");
centerLineParameters = removeNameValue(centerLineParameters, "Type");

% Boxplot
legendHandles = gobjects(1, nGroup);
legendLabels = cell(1, nGroup);
hold(ax, 'on');
for cIndex = 1:nCategory

    for gIndex = 1:nGroup
        left = boxEdgeLeft(cIndex, gIndex);
        right = boxEdgeRight(cIndex, gIndex);
        mid = (left + right) / 2;

        data = X{gIndex}(:, cIndex);

        % plot outliers
        params = outlierParameters;
        if strcmpi(outlierMarkerEdgeColor, "auto")
            params = changeNameValue(params, "MarkerEdgeColor", colors{gIndex}(cIndex, :));
        end
        if strcmpi(outlierMarkerFaceColor, "auto")
            params = changeNameValue(params, "MarkerFaceColor", colors{gIndex}(cIndex, :));
        end

        if strcmpi(outlierOpt, "show") && ~isempty(outliers{cIndex, gIndex})
            data = data(~ismember(data, outliers{cIndex, gIndex}));
            scatter(mid * ones(numel(outliers{cIndex, gIndex}), 1), outliers{cIndex, gIndex}, params{:});
        end

        % plot individual data points
        if strcmpi(individualDataPoint, "show")
            params = symbolParameters;
            if strcmpi(symbolMarkerFaceColor, "auto")
                params = changeNameValue(params, "MarkerFaceColor", colors{gIndex}(cIndex, :));
            end

            swarmchart(mid * ones(numel(data), 1), data, ...
                       "XJitterWidth", jitterWidth * min(diff(positions)), params{:});
        end
        
        % plot box
        params = boxParameters;
        if strcmpi(boxFaceColor, "auto")
            params = changeNameValue(params, "FaceColor", colors{gIndex}(cIndex, :));
        end

        if strcmpi(notchOpt, "on")
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
                                              "EdgeColor", colors{gIndex}(cIndex, :), ...
                                              params{:});
            if ~isempty(groupLegends) && numel(groupLegends) >= gIndex
                legendLabels{gIndex} = groupLegends{gIndex};
            end
        else
            patch(ax, "XData", xBox, ...
                      "YData", yBox, ...
                      "EdgeColor", colors{gIndex}(cIndex, :), ...
                      params{:});
        end
        
        % plot center line
        params = centerLineParameters;
        if strcmpi(CenterLineColor, "auto")
            params = changeNameValue(params, "Color", colors{gIndex}(cIndex, :));
        end

        if strcmpi(CenterLineType, 'mean')
            yCenterLine = mean(X{gIndex}(:, cIndex), 1, "omitnan");
        elseif strcmpi(CenterLineType, 'median')
            yCenterLine = median(X{gIndex}(:, cIndex), 1, "omitnan");
        else
            error("Invalid center line type");
        end
        line(ax, centerLineX, [yCenterLine, yCenterLine], params{:});

        % plot whisker
        if ~isempty(whisker)
            % whisker
            params = whiskerParameters;
            if strcmpi(whiskerColor, "auto")
                params = changeNameValue(params, "Color", colors{gIndex}(cIndex, :));
            end
            line(ax, [mid, mid], [bottom, whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [mid, mid], [top,    whiskerUpper(cIndex, gIndex)], params{:});
            
            % whisker cap
            params = whiskerCapParameters;
            if strcmpi(whiskerCapColor, "auto")
                params = changeNameValue(params, "Color", colors{gIndex}(cIndex, :));
            end
            line(ax, [mid - whiskerCapWidth / 2, mid + whiskerCapWidth / 2], ...
                     [whiskerLower(cIndex, gIndex), whiskerLower(cIndex, gIndex)], params{:});
            line(ax, [mid - whiskerCapWidth / 2, mid + whiskerCapWidth / 2], ...
                     [whiskerUpper(cIndex, gIndex), whiskerUpper(cIndex, gIndex)], params{:});
        end

        % plot group lines
        if groupLines && cIndex > 1
            xline(categoryEdgeLeft(cIndex));
        end

    end

end

if isempty(positions)
    xlim(ax, [0.5, nCategory + 0.5]);
end
drawnow;
setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, groupLabels, categoryLabels);

if ~all(cellfun(@isempty, groupLegends))
    validHandles = isgraphics(legendHandles);
    legend(ax, legendHandles(validHandles), legendLabels(validHandles), 'Location', 'best', 'AutoUpdate', 'off');
end

if nargout >= 1
    varargout{1} = ax;
end

if nargout == 2
    res = [];

    % Box edges: category-by-group
    res.boxEdgeLeft = boxEdgeLeft;
    res.boxEdgeRight = boxEdgeRight;
    res.boxCenters = (boxEdgeLeft + boxEdgeRight) / 2;
    res.boxEdgeLower = boxEdgeLower;
    res.boxEdgeUpper = boxEdgeUpper;
    res.q1 = q1;
    res.q3 = q3;
    res.median = q2;
    res.whiskerLower = whiskerLower;
    res.whiskerUpper = whiskerUpper;
    res.dimord = 'category_group';

    res.whisker = whisker;
    res.Positions = positions;
    res.centerLineType = CenterLineType;

    varargout{2} = res;
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
    boxCenters = (boxEdgeLeft + boxEdgeRight) / 2; % category-by-group

    if hasGroupLabels && ~hasCategoryLabels
        set(ax, 'XTick', sort(boxCenters(:), "ascend"), ...
                'XTickLabel', repmat(GroupLabels(:)', 1, nCategory));
    elseif ~hasGroupLabels && hasCategoryLabels
        set(ax, 'XTick', mean(boxCenters, 2), ...
                'XTickLabel', CategoryLabels);
    elseif hasGroupLabels && hasCategoryLabels
        % remove current xticklabels
        set(ax, 'XTick', sort(boxCenters(:), "ascend"), 'XTickLabel', []);

        % current axes positions
        pos = get(ax, "Position");
        labelAx = axes("Position", [pos(1), pos(2) - pos(4) * 0.15, pos(3), pos(4) * 0.15], "Visible", "off");

        % label position
        labelPosY_group = 0.8;
        labelPosY_category = 0.5;

        % group labels (primary labels)
        for gIndex = 1:nGroup
            for cIndex = 1:nCategory
                text(labelAx, boxCenters(cIndex, gIndex), labelPosY_group, GroupLabels{gIndex}, ...
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

        linkaxes([ax, labelAx], 'x');
        ylim(labelAx, [0, 1]);
    else
        set(ax, 'XTick', [], 'XTickLabel', []);
    end

    return;
end