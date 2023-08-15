function res = pathManager(ROOTPATH, varargin)
% Output:
%     res: struct array with fields [protocol] and [path]
% Standard storage:
%     ROOTPATH\subject\protocol\datetime\**\*.mat
% Example:
%     ROOTPATH = "D:\Education\Lab\Projects\Linear\MAT DATA";
%
%     % Find all
%     res = pathManager(ROOTPATH);
%
%     % Specify subjects only
%     res = pathManager(ROOTPATH, "subjects", ["DDZ", "DD"]);
%
%     % Specify protocols only
%     res = pathManager(ROOTPATH, "protocols", ["Noise", "ToneCF"]);
%
%     % Specify subjects and protocols
%     res = pathManager(ROOTPATH, "subjects", ["DDZ", "DD"], "protocols", "Noise");
%
%     % Specify mat file name with regexp
%     % Return mat file whose name starts with "AC"
%     res = pathManager(ROOTPATH, "matPat", "AC*");

mIp = inputParser;
mIp.addRequired("ROOTPATH", @(x) exist(x, "dir") ~= 0);
mIp.addParameter("subjects", [], @(x) isstring(x) || iscellstr(x) || ischar(x));
mIp.addParameter("protocols", [], @(x) isstring(x) || iscellstr(x) || ischar(x));
mIp.addParameter("matPat", "*", @(x) (isstring(x) && isscalar(x)) || (ischar(x) && isrow(x)));
mIp.addParameter("folderOnly", false, @(x) isscalar(x) && islogical(x));
mIp.parse(ROOTPATH, varargin{:});

subjects = mIp.Results.subjects;
protocols = mIp.Results.protocols;
matPat = mIp.Results.matPat;
folderOnly = mIp.Results.folderOnly;

if isempty(subjects)
    temp = dir(ROOTPATH);
    temp = temp(3:end);
    subjects = {temp([temp.isdir]).name}';
else
    switch class(subjects)
        case "string"
            subjects = reshape(subjects, [numel(subjects), 1]);
            subjects = mat2cell(subjects, ones(numel(subjects), 1));
        case "char"
            subjects = {subjects};
    end
end

if isempty(protocols)
    temp = cellfun(@(x) dir(fullfile(ROOTPATH, x)), subjects, "UniformOutput", false);
    temp = cellfun(@(x) x(3:end), temp, "UniformOutput", false);
    protocols = unique(mCell2mat(cellfun(@(x) {x.name}', temp, "UniformOutput", false)));
else
    switch class(protocols)
        case "string"
            protocols = reshape(protocols, [numel(protocols), 1]);
            protocols = mat2cell(protocols, ones(numel(protocols), 1));
        case "char"
            protocols = {protocols};
    end
end

temp = cellfun(@(x) rowFcn(@(y) dir(fullfile(ROOTPATH, y, x, strcat("**\", matPat, ".mat"))), subjects, "UniformOutput", false), protocols, "UniformOutput", false);
temp = cellfun(@(x) cellfun(@(y) arrayfun(@(z) fullfile(z.folder, z.name), y, "UniformOutput", false), x, "UniformOutput", false), temp, "UniformOutput", false);
temp = cellfun(@(x) mCell2mat(x), temp, "UniformOutput", false);
temp = cellfun(@string, temp, "UniformOutput", false);

if folderOnly
    temp = cellfun(@(x) mCell2mat(arrayfun(@(y) fileparts(y), x, "UniformOutput", false)), temp, "UniformOutput", false);
end

res = struct("protocol", protocols, "path", temp);

return;
end