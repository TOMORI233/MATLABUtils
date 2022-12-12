function deleteItem(rootPath, keyword)
narginchk(1, 2);
if nargin > 1
    rootPath = string(rootPath);
    keyword = string(keyword);
    temp = dir(strcat(rootPath, "\**\*"));
    mPath = fullfile(string({temp.folder}'), string({temp.name}'));
    dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir);
    fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir);
else
    mPath = rootPath;
    dirIndex = logical(exist(mPath, "dir"));
    fileIndex = logical(exist(mPath, "file"));
end

% delete folders
if any(dirIndex)
    rmPath = cellstr(mPath(dirIndex));
    rmdir(rmPath{:}, 's');
%     cellfun(@(x) rmdir(x, "s"), rmPath, "uni", false);
end
% delete files
if any(fileIndex)
    rmPath = cellstr(mPath(fileIndex));
    delete(rmPath{:});
end
end
