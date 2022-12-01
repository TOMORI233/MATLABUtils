function deleteItem(rootPath, itemName, keyword)
narginchk(2, 3);
if nargin < 3
    [Path, temp] = getSubfoldPath(rootPath, itemName);
else
    [Path, temp] = getSubfoldPath(rootPath, itemName, strcat(keyword, itemName));
end

for i = 1 : length(Path)
     if temp(i).isdir
         rmdir(Path{i},'s');
     else
         delete(Path{i});
     end
end
end
