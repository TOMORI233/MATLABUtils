function mAxe = mSubplotSPR(row, col, index, margins, paddings)
    narginchk(3, 5);
    nSize = [1, 1];
    if nargin == 3
        paddings = 0.01 * ones(1, 4);
        margins = 0.07 * ones(1, 4);
    elseif nargin == 4
        paddings = 0.01 * ones(1, 4);
    end

    % nSize = [nX, nY]
    nX = nSize(1);
    nY = nSize(2);

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
    divY = 1 - paddings(4) - divHeight * (rIndex + nY - 1);
    axeX = divX + margins(1) * divWidth * nX;
    axeY = divY + margins(3)*1.5 * divHeight * nY;

    nX = length(unique(axeX)); % mSubplot(Fig,2,2,[1 2]);
    nY = length(unique(axeY));

    axeWidth = (1 - margins(1) - margins(2)) * divWidth * nX + 0.5 * (nX-1) * margins(1);
    axeHeight = (1 - margins(3)*1.5 - margins(4)*1.5) * divHeight * nY + 0.5 * (nY-1) * margins(3);

    axeX = axeX(1);
    axeY = axeY(1);
    
%     divAxe = axes(Fig, "Position", [divX, divY, divWidth * nX, divHeight * nY], "Box", "on");
    mAxe = axes(gcf, "Position", [axeX, axeY, axeWidth, axeHeight], "Box", "off");

    return;
end
