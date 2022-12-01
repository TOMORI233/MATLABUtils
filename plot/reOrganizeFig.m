function Fig = reOrganizeFig(Fig, varargin)

%% Validate input
mInputParser = inputParser;
mInputParser.addRequired("Fig", @isgraphics);
mInputParser.addParameter("paddings", [0.01, 0.03, 0.01, 0.01], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));
mInputParser.addParameter("margins", [0.05, 0.05, 0.1, 0.1], @(x) validateattributes(x, 'numeric', {'vector', 'numel', 4}));

mInputParser.parse(Fig, varargin{:});
paddingsNew = mInputParser.Results.paddings;
marginsNew = mInputParser.Results.margins;

for fIndex = 1 : length(FigGroup)
    FigGroup.Units = "normalized";
    Axes = findobj(FigGroup, "Type", "axes");
end

figure("Units", "normalized")


end