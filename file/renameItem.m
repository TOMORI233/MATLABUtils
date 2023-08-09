function renameItem(rootPath, keyword, newName, varargin)
% Description: batch rename file or folder name
% Input:
%       rootpath: ROOTPATH
%       keyword: the raw file or folder name used to find 
%       newName: the string to replace the raw name
%       folderOrFile: decide rename file or folder

mIp = inputParser;
mIp.addRequired("rootPath", @isstring);
mIp.addRequired("keyword", @isstring);
mIp.addRequired("newName", @isstring);
mIp.addParameter("folderOrFile", "all", @(x) any(validatestring(x, {'all', 'file', 'folder'})));
mIp.parse(rootPath, keyword, newName, varargin{:});

folderOrFile = mIp.Results.folderOrFile;

rootPath = string(rootPath);
keyword = string(keyword);
temp = dir(strcat(rootPath, "\**\*"));
mPath = fullfile(string({temp.folder}'), string({temp.name}'));
dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);

% rename folders
if any(dirIndex) && matches(folderOrFile, ["all", "folder"])
    rmPath = cellstr(mPath(dirIndex));
    cellfun(@(x) movefile(x, strrep(x, keyword, newName)), rmPath, "UniformOutput", false)
end
% rename files
if any(fileIndex) && matches(folderOrFile, ["all", "file"])
    rmPath = cellstr(mPath(fileIndex));
    cellfun(@(x) movefile(x, strrep(x, keyword, newName)), rmPath, "UniformOutput", false)
end

end