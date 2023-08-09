temp = dirItem("E:\MonkeyLinearArray\Figure\CTL_New", "res.mat");
temp(contains(temp, "MGB")) = [];
oldPath = cellfun(@(x) erase(x, "\res.mat"), temp, "uni", false);
newPath = cellfun(@(x) strcat(x, "_AC"), oldPath, "UniformOutput", false);
cellfun(@(x, y) movefile(x, y), oldPath, newPath, "UniformOutput", false);