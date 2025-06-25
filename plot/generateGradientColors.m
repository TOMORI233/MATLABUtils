function rgb = generateGradientColors(n, rgbOpt, smin)
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

    hsv = repmat(hsv, [n, 1]);
    hsv(:, 2, :) = linspace(smin, 1, n);
    rgb = hsv2rgb(hsv);
    rgb = mat2cell(rgb, ones(size(rgb, 1), 1));
    return;
end