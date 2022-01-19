function mAxe = mSubplot(Fig, row, col, index, paddings, margins)
    narginchk(4, 6);

    if nargin == 4
        paddings = 0.01 * ones(1, 4);
        margins = 0.01 * ones(1, 4);
    elseif nargin == 5
        margins = 0.01 * ones(1, 4);
    end

    % paddings or margins is [Left, Right, Bottom, Top]
    divWidth = (1 - paddings(1) - paddings(2)) / col;
    divHeight = (1 - paddings(3) - paddings(4)) / row;
    rIndex = ceil(index / col);

    if rIndex > row
        error('index > col * row');
    end

    cIndex = mod(index, col);

    if cIndex == 0
        cIndex = col;
    end

    divX = paddings(1) + divWidth * (cIndex - 1);
    divY = 1 - paddings(4) - divHeight * rIndex;
    axeX = divX + margins(1);
    axeY = divY + margins(3);
    axeWidth = divWidth - (margins(1) + margins(2));
    axeHeight = divHeight - (margins(3) + margins(4));

    % divAxe = axes(Fig, "Position", [divX, divY, divWidth, divHeight], "Box", "on");
    mAxe = axes(Fig, "Position", [axeX, axeY, axeWidth, axeHeight], "Box", "on");

    return;
end
