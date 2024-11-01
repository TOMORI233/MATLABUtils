function rgb = mixColors(color1, color2, ratio)
    narginchk(2, 3);

    if nargin < 3
        ratio = [0.5, 0.5];
    end

    rgb1 = validatecolor(color1);
    rgb2 = validatecolor(color2);

    if isreal(ratio) && numel(ratio) == 2
        ratio = ratio ./ sum(ratio);
        rgb = rgb1 - (rgb1 - rgb2) * (1 - ratio(1));
    else
        error("Invalid input")
    end

    return;
end