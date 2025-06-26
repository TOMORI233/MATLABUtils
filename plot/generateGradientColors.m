function rgb = generateGradientColors(n, rgbOpt, smin)
% Generate gradient colors from specified [rgbOpt] to white.
% Inputs:
%   n: number of colors
%   rgbOpt: initial color, either a string ('r','g','b') or an RGB triplet (range [0,1])
%   smin: the minimum saturation (at the white end). Default is 0 (for white).
%
% Output:
%   rgb: n x 3 matrix of RGB colors, each row is one color.

narginchk(1, 3);

if nargin < 2
    rgbOpt = "r";
end

if nargin < 3
    smin = 0.2; % min saturation, [0, 1]
end

if isstring(rgbOpt) || ischar(rgbOpt)
    switch rgbOpt
        case "r"
            hsv = rgb2hsv([1, 0, 0]);
        case "g"
            hsv = rgb2hsv([0, 1, 0]);
        case "b"
            hsv = rgb2hsv([0, 0, 1]);
        otherwise
            error("Invalid color string input");
    end
elseif isnumeric(rgbOpt)
    hsv = rgb2hsv(rgbOpt);
end

s0 = hsv(2);
v0 = hsv(3);
hsv = repmat(hsv, [n, 1]);
hsv(:, 2) = linspace(s0, smin, n);
hsv(:, 3) = linspace(v0, 1, n);

rgb = hsv2rgb(hsv);
rgb = mat2cell(rgb, ones(size(rgb, 1), 1));
return;
end