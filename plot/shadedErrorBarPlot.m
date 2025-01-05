function shadedErrorBarPlot(x, y, err, fillColor, alphaValue, varargin)
    % x: x 轴数据
    % y: y 轴数据
    % err: 误差数据 (正负误差条)
    % fillColor: 阴影填充颜色 (如 'r', 'g', 'b')
    % alphaValue: 阴影透明度（0 到 1）
    % varargin: 可选的 'plot' 属性（如 'LineWidth', 'LineStyle' 等）

    % 检查输入参数的长度一致性
    if length(x) ~= length(y) || length(y) ~= length(err)
        error('x, y, and err must have the same length.');
    end

    % 创建误差区域
    x_full = [x(:); flipud(x(:))]; 
    y_upper = y(:) + err(:);  % 上边界
    y_lower = y(:) - err(:);  % 下边界
    y_full = [y_upper; flipud(y_lower)];

    % 绘制阴影区域
    fill(x_full, y_full, fillColor, 'FaceAlpha', alphaValue, 'EdgeColor', 'none');
    hold on;

    % 绘制数据线，传递可选参数给 plot 函数
    plot(x, y, varargin{:});

    % 添加网格和标签
    grid on;
%     xlabel('X');
%     ylabel('Y');
%     title('Shaded Error Bar Plot');
end