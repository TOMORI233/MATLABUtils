function optimalK = findElbow(SSE)
    % 输入：SSE 是 Sum of Squared Errors 的数组
    % 输出：optimalK 是最佳聚类数
    
    nPoints = length(SSE); % 数据点个数
    allIndices = 1:nPoints;

    % 获取曲线的两端点
    firstPoint = [1, SSE(1)];
    lastPoint = [nPoints, SSE(end)];

    % 计算直线参数
    lineVec = lastPoint - firstPoint;
    lineVecNorm = lineVec / norm(lineVec); % 归一化方向向量

    % 计算每个点到直线的垂直距离
    distances = zeros(nPoints, 1);
    for i = 1:nPoints
        point = [allIndices(i), SSE(i)];
        vecToPoint = point - firstPoint;
        projOntoLine = dot(vecToPoint, lineVecNorm) * lineVecNorm;
        vecToLine = vecToPoint - projOntoLine;
        distances(i) = norm(vecToLine);
    end

    % 找到最大距离对应的点
    [~, optimalK] = max(distances);
end