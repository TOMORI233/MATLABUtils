function renameItem(rootPath, keyword, newName)

    rootPath = string(rootPath);
    keyword = string(keyword);
    temp = dir(strcat(rootPath, "\**\*"));
    mPath = fullfile(string({temp.folder}'), string({temp.name}'));
    dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
    fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);

% rename folders
if any(dirIndex)
    rmPath = cellstr(mPath(dirIndex));
    cellfun(@(x) movefile(x, strrep(x, keyword, newName)), rmPath, "UniformOutput", false)
end
% rename files
if any(fileIndex)
    rmPath = cellstr(mPath(fileIndex));
    cellfun(@(x) movefile(x, strrep(x, keyword, newName)), rmPath, "UniformOutput", false)
end

end