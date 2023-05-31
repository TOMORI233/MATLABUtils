%% Demo of creating context menu
clear; clc; close all;
Fig = figure;

%% plot
dataAll = (1:10) .* [1;2;3];
set(Fig, "UserData", []);
mAxe = mSubplot(Fig, 1, 1, 1, 1, [0, 0, 0, 0], [0.1, 0.1, 0.1, 0.1]);
cm = uicontextmenu(Fig);
m = uimenu(cm, 'Text', 'select points');
mAxe.ContextMenu = cm;
set(m, "MenuSelectedFcn", {@mMenu, Fig});

for index = 1:3
    info.index = index;
    info.block = ['Block-', num2str(index)];
    plot(mAxe, dataAll(index, :), "DeleteFcn", {@mDeleteFcn, Fig}, "UserData", info, "ButtonDownFcn", @mBtnDownFcn);
    hold on;
    grid on;
end

%% test
DTO = get(Fig, "UserData");
idx = getOr(DTO, "idx");
dataAll(idx, :) = [];
disp(dataAll);

% in = inpolygon(1:10, dataAll(1, :), DTO.xv, DTO.yv);

%% deleteFcn
function mDeleteFcn(handle, eventdata, Fig)
    DTO = get(Fig, "UserData");
    info = get(handle, "UserData");
    idx = getOr(DTO, "idx");
    idx = [idx, info.index];
    DTO.idx = idx;
    set(Fig, "UserData", DTO);
end

%% buttondownfcn
function mBtnDownFcn(handle, eventdata)
    info = get(handle, "UserData");
    lastClick = getOr(info, "lastClick");

    if eventdata.Button == 1
        if ~isempty(lastClick) && (now - lastClick) * 24 * 3600 <= 0.5
            info = get(handle, "UserData");
            Msgbox(info.block);
        else
            lastClick = now;
        end
    end

    info.lastClick = lastClick;
    set(handle, "UserData", info);
end

%% MenuSelectedFcn
function mMenu(handle, eventdata, Fig)
    set(handle, "Enable", "off");
    xv = [];
    yv = [];
    lines = [];
    
    while 1
        [x, y, btn] = ginput(1);
    
        if ~isempty(btn)
    
            if btn == 1
    
                if ~isempty(xv)
                    ltemp = plot([xv(end), x], [yv(end), y], "k.-", "LineWidth", 1);
                else
                    ltemp = plot(x, y, "k.-", "LineWidth", 1);
                end
    
                xv = [xv, x];
                yv = [yv, y];
                lines = [lines, ltemp];
            elseif btn == 'z'

                if ~isempty(lines)
                    delete(lines(end));
                    lines = lines(1:end - 1);
                    xv = xv(1:end - 1);
                    yv = yv(1:end - 1);
                end

            end
    
        else
            plot([xv(end), xv(1)], [yv(end), yv(1)], "k.-", "LineWidth", 1);
            break;
        end
    
    end

    DTO = get(Fig, "UserData");
    DTO.xv = xv;
    DTO.yv = yv;
    set(Fig, "UserData", DTO);
    set(handle, "Enable", "on");
end