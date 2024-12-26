function mExportgraphics(targets, varargin)
% This function is an extension of built-in function exportgraphics
% It aims to export multiple axes by creating a new figure and copying
% objects (your axes or panels) into that new figure.

newFig = figure;
arrayfun(@(x) copyobj(x, newFig), targets);
exportgraphics(newFig, varargin{:});
close(newFig);

return;
end