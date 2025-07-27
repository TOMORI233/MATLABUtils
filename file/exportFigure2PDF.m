function exportFigure2PDF(figHandle, filename, width_mm, height_mm)
% Make a copy of figure and export to PDF with specified [width, height]
%
% Parameters:
%   figHandle   - figure handle
%   filename    - full file name of PDF
%   width_mm    - with, in mm
%   height_mm   - height, in mm

arguments
    figHandle   matlab.ui.Figure
    filename    char
    width_mm    double
    height_mm   double
end

% convert mm to inches
width_in = width_mm / 25.4;
height_in = height_mm / 25.4;

% make a copy of figure
tempFig = copyobj(figHandle, 0);  % copy to root
set(tempFig, 'Visible', 'off');  % invisible

% parameter settings
set(tempFig, 'Units', 'inches');
set(tempFig, 'Position', [1, 1, width_in, height_in]);
set(tempFig, 'PaperUnits', 'inches');
set(tempFig, 'PaperSize', [width_in, height_in]);
set(tempFig, 'PaperPositionMode', 'manual');
set(tempFig, 'PaperPosition', [0, 0, width_in, height_in]);

% export
exportgraphics(tempFig, filename, ...
               'ContentType', 'vector', ...
               'BackgroundColor', 'none');

% close copy
close(tempFig);

return;
end
