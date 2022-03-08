function Fig = plotTuning(cellData, visibilityOpt)
    %% Plot settings
    window = cellData.windowParams.window;

    %% Plotting
    plotData = cellData.data;

    Fig = figure;
    set(Fig, "visible", visibilityOpt, "outerposition", get(0, "screensize"));

    rasterWidth = 0.9 / size(plotData, 1);
    FR = [];

    for fIndex = 1:size(plotData, 1)
        trials = plotData(fIndex).trials;
        rasterHeight = 0.5 / size(trials, 1);

        for aIndex = 1:size(trials, 1)
            mAxe = axes("Position", [0.05 + rasterWidth * (fIndex - 1), 0.9 - rasterHeight * (aIndex - 1), rasterWidth, rasterHeight], "Box", "on");

            % Raster
            for tIndex = 1:size(trials(aIndex).spikes, 1)
                X = trials(aIndex).spikes{tIndex};
                Y = ones(length(X), 1) * tIndex;
                plot(X, Y, "r.", "MarkerSize", 10); hold on;
            end

            ylim([0, tIndex + 1]);
%             xlim([0, max([100, window(2)]) * 1.1]);
            xlim([0, window(2) * 1.1])

            set(gca, 'YTickLabel', '');

            if aIndex < size(trials, 1) || fIndex > 1
                set(gca, 'XTickLabel', '');
            end

            if fIndex == 1
                ylabel(num2str(trials(aIndex).amp));
            end

            if aIndex == 1
                title(num2str(plotData(fIndex).freq));
            end

            % Rate
            FR(aIndex, fIndex) = length(cell2mat(trials(aIndex).spikes)) / size(trials(aIndex).spikes, 1) / ((window(2) - window(1)) / 1000);
        end

    end

    axes('Position', [0.05, 0.05, 0.9, 0.4]);
    image(FR, 'CDataMapping', 'scaled');
    colorbar("Position", [0.96, 0.05, 0.02, 0.4]);
    drawnow;

    return;
end
