function rgb = generateGradientColors(n, rgbOpt, smin)
    narginchk(1, 3);

    if nargin < 2
        rgbOpt = "r";
    end

    if nargin < 3
        smin = 0.2; % min saturation, [0, 1]
    end

    switch rgbOpt
        case "r"
            hsi = rgb2hsv([1, 0, 0]);
        case "g"
            hsi = rgb2hsv([0, 1, 0]);
        case "b"
            hsi = rgb2hsv([0, 0, 1]);
        otherwise
            hsi = rgb2hsv(rgbOpt);
    end

    hsi = repmat(hsi, [n, 1]);
    hsi(:, 2, :) = linspace(smin, 1, n);
    rgb = hsv2rgb(hsi);
    rgb = mat2cell(rgb, ones(size(rgb, 1), 1));
    return;
end