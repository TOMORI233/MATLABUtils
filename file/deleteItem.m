function deleteItem(rootPath, keyword)

narginchk(1, 2);

if nargin > 1
    rootPath = string(rootPath);
    keyword = string(keyword);
    temp = dir(strcat(rootPath, "\**\*"));
    mPath = fullfile(string({temp.folder}'), string({temp.name}'));
    temp(contains(mPath, ["\.", "\.."]))=[];
    mPath(contains(mPath, ["\.", "\.."]))=[];
    dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir);
    fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir);
else
    mPath = rootPath;
    mPath(contains(mPath, ["\.", "\.."]))=[];
    dirIndex = logical(exist(mPath, "dir"));
    fileIndex = logical(exist(mPath, "file"));
end

% delete folders
if any(dirIndex)

    rmPath = cellstr(mPath(dirIndex));
%     n=10;
%     for dIndex = 1 : floor(length(rmPath)/n)
%         temp = rmPath((dIndex-1)*n+1:dIndex*n);
%         rmdir(temp{:}, 's');
%     end
%     temp = rmPath(dIndex*n+1:end);
%     rmdir(rmPath{:}, 's');
    cellfun(@(x) rmdir(x,"s"), rmPath, "UniformOutput", false);
end

% delete files
if any(fileIndex)
    rmPath = cellstr(mPath(fileIndex));
    delete(rmPath{:});
end

end
