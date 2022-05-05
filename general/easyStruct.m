function res = easyStruct(fieldName,fieldVal)
evalstr=['res=struct('];
%% if certain field is double defined, delete the old one
deleteIdx= [];
fieldN = unique(fieldName);
if length(fieldN) ~= length(fieldName)
    for i = 1:length(fieldN)
        if sum(strcmp(fieldName,fieldN{i})) > 1
            idx = find(strcmp(fieldName,fieldN{i}));
            reserveIdx = max(find(strcmp(fieldName,fieldN{i})));
            deleteIdx = [deleteIdx ; idx(idx~=reserveIdx)]'
        end
    end
end
fieldName(deleteIdx) = [];
fieldVal(:,deleteIdx) = [];

for Paranum=1:length(fieldName)
    evalstr=[ evalstr '''' fieldName{Paranum} ''',' 'fieldVal(:,' num2str(Paranum) '),'];
end
evalstr(end)=[')'];
evalstr=[evalstr ';'];
eval(evalstr);
