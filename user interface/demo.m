clear; clc; close all;
Fig = figure;

%% plot
data = 1:10;
dataAll = data .* [1;2;3];
set(Fig, "UserData", []);

for index = 1:3
    info.index = index;
    info.block = "Block-1";
    plot(dataAll(index, :), "DeleteFcn", {@mDeleteFcn, Fig}, "UserData", info, "ButtonDownFcn", @mBtnDownFcn);
    hold on;
end

%% test
idx = get(Fig, "UserData");
dataAll(idx, :) = [];
disp(dataAll);

%% deleteFcn
function mDeleteFcn(handle, eventdata, Fig)
    y = get(Fig, "UserData");
    info = get(handle, "UserData");
    y = [y, info.index];
    set(Fig, "UserData", y);
end

%% buttondownfcn
function mBtnDownFcn(handle, eventdata)
    info = get(handle, "UserData");
    Msgbox(info.block);
end