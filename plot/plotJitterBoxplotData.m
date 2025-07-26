function plotJitterBoxplotData(varargin)
% [X] can be a cell array or a 2-D matrix.
% If [X] is matrix, each column s a group.
% [G] is x-values of the group.
% [jitter] specifies the jitter level (default: 0.1).

if isgraphics(varargin{1}(1), "axes")
    ax = varargin{1}(1);
    varargin = varargin(2:end);
else
    ax = gca;
end

mIp = inputParser;
mIp.addRequired("ax", @(x) isgraphics(x, "axes"));
mIp.addRequired("X", @(x) validateattributes(x, {'numeric', 'cell'}, {'2d'}));
mIp.addOptional("G", [], @(x) validateattributes(x, 'numeric', {'vector'}));
mIp.addOptional("jitter", 0.1, @(x) validateattributes(x, 'numeric', {'scalar'}));
mIp.addParameter("Marker", 'o');
mIp.addParameter("MarkerSize", 6, @(x) validateattributes(x, 'numeric', {'scalar', 'positive'}));
mIp.addParameter("Alpha", 6, @(x) validateattributes(x, 'numeric', {'scalar', 'positive'}));
mIp.parse(ax, varargin{:});

X = mIp.Results.X;
G = mIp.Results.G;
jitter = mIp.Results.jitter;

if isnumeric(X)
    X = num2cell(X, 1);
end

if isempty(G)
    G = 1:numel(X);
end

if numel(X) ~= numel(G)
    error("Group number not matched");
end

if all(diff(G) ~= mode(diff(G)))
    error("Group numbers should be equally spaced");
else
    dG = mode(diff(G));
end

for gIndex = 1:numel(G)
    swarmchart(G(gIndex) * ones(numel(X{gIndex}), 1), X{gIndex}, "XJitterWidth", jitter, "MarkerEdgeColor", "w", "MarkerFaceColor", "r", "MarkerFaceAlpha", 0.5, "LineWidth", 0.1);
end

end