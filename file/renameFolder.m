temp = dirItem("E:\MonkeyLinearArray\MAT Data\CM\CTL_New\TB_Ratio_4_4.04", "spkData.mat","folderOrFile", "file");

temp(contains(temp, "MGB")) = [];
oldPath = cellfun(@(x) erase(x, "\spkData.mat"), temp, "uni", false);
newPath = cellfun(@(x) strcat(x, "_AC"), oldPath, "UniformOutput", false);
cellfun(@(x, y) movefile(x, y), oldPath, newPath, "UniformOutput", false);