function Path = dirItem(rootPath, keyword)
rootPath = string(rootPath);
keyword = string(keyword);
temp = dir(strcat(rootPath, "\**\*"));
mPath = fullfile(string({temp.folder}'), string({temp.name}'));
dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
Path = cellstr(mPath(dirIndex|fileIndex));