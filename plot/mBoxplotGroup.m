function varargout = mBoxplotGroup(varargin)

if isgraphics(varargin{1}(1), "axes")
    ax = varargin{1}(1);
    varargin = varargin(2:end);
else
    ax = gca;
end

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
mIp.addParameter("BoxParameters", {"LineStyle", "-", ...
                                   "LineWidth", 0.5, ...
                                   "FaceColor", "none", ...
                                   "FaceAlpha", 0});
mIp.addParameter("CenterLineParameters", {"Type", "Mean", ...
                                          "LineStyle", "-", ...
                                          "LineWidth", 0.5, ...
                                          "Color", "auto"});
mIp.addParameter("WhiskerParameters", {"LineStyle", "-", ...
                                       "LineWidth", 0.5, ...
                                       "Color", "auto"});
mIp.addParameter("WhiskerCapParameters", {"LineStyle", "-", ...
                                          "LineWidth", 0.5, ...
                                          "Color", "auto", ...
                                          "Width", 0.4});
mIp.addParameter("IndividualDataPoint", "show", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.addParameter("SymbolParameters", {"Marker", "o", ...
                                      "MarkerEdgeColor", "w", ...
                                      "MarkerFaceColor", "r", ...
                                      "MarkerFaceAlpha", 0.3, ...
                                      "LineWidth", 0.1}, @(x) iscell(x));
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
BoxParameters = mIp.Results.BoxParameters;
CenterLineParameters = mIp.Results.CenterLineParameters;
Whisker = mIp.Results.Whisker;
WhiskerParameters = mIp.Results.WhiskerParameters;
WhiskerCapParameters = mIp.Results.WhiskerCapParameters;
IndividualDataPoint = mIp.Results.IndividualDataPoint;
SymbolParameters = mIp.Results.SymbolParameters;
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
    if iseuqal(cellfun(@(x) size(x, 1), Colors), nCategory)
        
    else % specifies colors for each category by looping assignment
        Colors = mCell2mat(Colors);
        Colors = repmat(Colors, ceil(sum(nCategory) / size(Colors, 1)), 1);
        Colors = Colors(1:sum(nCategory));
        Colors = mat2cell(Colors, nCategory, []);
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
            swarmchart(boxCenter * ones(numel(X{gIndex}(:, cIndex)), 1), X{gIndex}(:, cIndex), ...
                       "XJitterWidth", Jitter, SymbolParameters{:});
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
        end
        line(ax, [left, right], [yCenterLine, yCenterLine], params{:});

        % plot whisker
        if ~isempty(Whisker)
            % whisker
            idx = find(cellfun(@(x) strcmpi(x, "Color"), WhiskerParameters), 1);
            if ~isempty(idx) && strcmpi(WhiskerParameters{idx + 1}, "auto")
                params = WhiskerParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
            end
            line(ax, [boxCenter, boxCenter], [bottom, whiskerLower{gIndex}(cIndex)], params{:});
            line(ax, [boxCenter, boxCenter], [top,    whiskerUpper{gIndex}(cIndex)], params{:});
            
            % whisker cap
            idx = find(cellfun(@(x) strcmpi(x, "Color"), WhiskerCapParameters), 1);
            if ~isempty(idx) && strcmpi(WhiskerCapParameters{idx + 1}, "auto")
                params = WhiskerCapParameters;
                params{idx + 1} = Colors{gIndex}(cIndex, :);
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
hold(ax, 'off');

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

function setupAxisLabels(ax, nGroup, nCategory, boxEdgeLeft, boxEdgeRight, GroupLabels, CategoryLabels)
    % 设置分组和类别标签
    
    % 清除现有标签
    set(ax, 'XTickLabel', [], 'XTick', []);
    
    % 计算标签位置
    groupCenters = cellfun(@(l,r) mean([l(:), r(:)], 2), boxEdgeLeft, boxEdgeRight, 'UniformOutput', false);
    categoryCenters = cellfun(@(l,r) (l + r)/2, boxEdgeLeft, boxEdgeRight, 'UniformOutput', false);
    
    % 获取当前坐标轴位置
    axPos = get(ax, 'Position');
    ylims = ylim(ax);
    labelYPos = ylims(1) - 0.01 * diff(ylims);
    
    % 绘制分组标签 (主标签)
    if ~all(cellfun(@isempty, GroupLabels)) && numel(GroupLabels) == nGroup
        for g = 1:nGroup
            text(ax, mean(groupCenters{g}), labelYPos, GroupLabels{g}, ...
                 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'top', ...
                 'FontWeight', 'bold', ...
                 'FontSize', get(ax, 'FontSize'));
        end
    end
    
    % 绘制类别标签 (次标签)
    if ~all(cellfun(@isempty, CategoryLabels)) && numel(CategoryLabels) >= max(nCategory)
        for g = 1:nGroup
            for c = 1:nCategory(g)
                text(ax, categoryCenters{g}(c), labelYPos - 0.01 * diff(ylims), CategoryLabels{c}, ...
                     'HorizontalAlignment', 'center', ...
                     'VerticalAlignment', 'top', ...
                     'FontSize', get(ax, 'FontSize') * 0.9);
            end
        end
    end

end