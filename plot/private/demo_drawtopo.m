ccc;

data = peaks(8);
[x, y] = meshgrid(1:8, 1:8);

figure;
ax = mSubplot(1, 1, 1, "shape", "square-min");
axis on;  % 显示坐标轴
hold on;  % 保持绘图状态，允许在图像上添加内容
C = data;
C = padarray(C, [1, 1], "replicate");
C = interp2(C, 5);
C = imgaussfilt(C, 8);
X = linspace(0, 9, size(C, 1));
Y = linspace(0, 9, size(C, 2));
imagesc(ax, "XData", X, "YData", Y, "CData", C);
h = scatter(x(:), y(:), 50, data(:), "filled");
xlim([0, 9]);
ylim([0, 9]);


for nsection = 1:3
    % 手动绘制曲线
    x_points = [];  % 存储x坐标
    y_points = [];  % 存储y坐标
    lines = [];
    while true
        % 获取鼠标点击的点
        [x, y, button] = ginput(1);

        % 如果按下的是回车键，退出循环
        if isempty(button)
            break;
        end

        if button == 122 % z
            if ~isempty(lines)
                x_points(end) = [];
                y_points(end) = [];
                delete(lines(end));
                lines(end) = [];
            end
            continue;
        end

        % 存储点
        x_points = [x_points; x];
        y_points = [y_points; y];

        % 绘制曲线
        if length(x_points) > 1
            lines = [lines, plot(x_points(end-1:end), y_points(end-1:end), 'k.-', 'LineWidth', 6, "MarkerSize", 20)];
        else
            lines = [lines, plot(x, y, 'k.', "MarkerSize", 20)];  % 绘制第一个点
        end
    end
    delete(lines);

    % 平滑曲线
    x_smooth = smoothdata(x_points, 'movmean', 5);  % 平滑 x 数据
    y_smooth = smoothdata(y_points, 'movmean', 5);  % 平滑 y 数据

    % 绘制平滑后的线条
    plot(x_smooth, y_smooth, 'k.-', 'LineWidth', 6, "MarkerSize", 20);
    uistack(h, "bottom");
end

% 显示最终结果
disp('曲线绘制完成！');
addLines2Axes(ax, struct("X", {0; 9}, "color", "k", "width", 0.5, "style", "-"));
addLines2Axes(ax, struct("Y", {0; 9}, "color", "k", "width", 0.5, "style", "-"));
axis off;

% exportgraphics(ax, "cc_AC_sulcus_square.jpg", "Resolution", 300);
% exportgraphics(ax, "cc_PFC_sulcus_square.jpg", "Resolution", 300);
% exportgraphics(ax, "xx_AC_sulcus_square.jpg", "Resolution", 300);
% exportgraphics(ax, "xx_PFC_sulcus_square.jpg", "Resolution", 300);
