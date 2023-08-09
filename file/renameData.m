PATH = dirItem("E:\MonkeyLinearArray\MAT Data\CM","data.mat");
for pIndex = 1 : length(PATH)
    load(PATH{pIndex});
    if isfield(data, "spkWave")
        
        SAVEPATH = strrep(PATH{pIndex}, "data.mat", "spkWave.mat");
        spkWave = data.spkWave;
        save(SAVEPATH, "spkWave", "-v7.3");

        data = rmfield(data, "spkWave");
    end
        dataTemp = data;

        % save spkData
        if isfield(dataTemp, "Wave")
            data = rmfield(dataTemp, ["lfp", "Wave"]);
        else
            data = rmfield(dataTemp, "lfp");
        end
        SAVEPATH = strrep(PATH{pIndex}, "data.mat", "spkData.mat");
        save(SAVEPATH, "data", "-v7.3");

        % save lfpData
        if isfield(dataTemp, "spikeRaw")
            data = rmfield(dataTemp, ["spikeRaw", "sortdata"]);
        else
            data = rmfield(dataTemp, "sortdata");
        end
        SAVEPATH = strrep(PATH{pIndex}, "data.mat", "lfpData.mat");
        save(SAVEPATH, "data", "-v7.3");
end

