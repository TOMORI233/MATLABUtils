function renameFile(rootPath, oldName, newName, keyword)

narginchk(3, 4);
if nargin < 4
    Path = getSubfoldPath(rootPath, oldName, oldName);
else
    Path = getSubfoldPath(rootPath, oldName, strcat(keyword, oldName));
end


for i = 1 : length(Path)
eval(strcat("!rename,", Path{i}, ",", newName));
end
end
