function syncRepositories(logstr, varargin)
% Description: This function updates all repositories in the specified root path.
%              You can also specify repository paths to update.
%              Your local changes will be committed and remote changes will be pulled.
%
% To push local changes to remote, set [SyncOption] as true. (default: false)
% e.g.       sycnRepositories("add new functions", "SyncOption", true);
%
% If [RepositoryPaths] is not specified (default: []), [RepositoryPaths] will
% be all repository paths under [RepositoriesRootPath] (default: root path of this M file).
% e.g.       % Search all repositories under path 'D:\'
%            sycnRepositories(logstr, ...
%                             "RepositoriesRootPath", 'D:\');
%
% You can also specify repository paths to update.
% e.g.       sycnRepositories(logstr, ...
%                             "RepositoryPaths", ["D:\repos1\", ...
%                                                 "D:\Project2\repos2\"]);
%

mIp = inputParser;
mIp.addRequired("logstr", @(x) isempty(x) || isStringScalar(x) || (ischar(x) && isStringScalar(char(x))));
mIp.addParameter("SyncOption", false, @(x) isscalar(x) && islogical(x));
mIp.addParameter("RepositoriesRootPath", [], @(x) isStringScalar(x) || (ischar(x) && isStringScalar(char(x))));
mIp.addParameter("RepositoryPaths", [], @(x) iscellstr(x) || isstring(x));
mIp.parse(logstr, varargin{:});

SyncOption = mIp.Results.SyncOption;
RepositoriesRootPath = mIp.Results.RepositoriesRootPath;
RepositoryPaths = mIp.Results.RepositoryPaths;

if isempty(RepositoryPaths)
    disp(['Searching repositories in: ', getAbsPath(RepositoriesRootPath)]);
    RepositoryPaths = dir(fullfile(RepositoriesRootPath, "**\.git\"));
    RepositoryPaths = unique({RepositoryPaths.folder})';

    if ~isempty(RepositoryPaths)
        RepositoryPaths = cellfun(@(x) getRootDirPath(x, 1), RepositoryPaths, "UniformOutput", false);
        disp('The following repositories are found: ');
        cellfun(@disp, RepositoryPaths);
    else
        disp('No repositories found in this directory');
        return;
    end

else

    if ~isempty(RepositoryPaths)

        if isstring(RepositoryPaths)
            RepositoryPaths = arrayfun(@char, RepositoryPaths, "UniformOutput", false);
        end

    else
        error("syncRepositories(): repository paths should be user-specified if SearchMethod is set 'custom'.");
    end

end

currentPath = pwd;
[~, currentUser] = system("whoami");
currentUser = strrep(currentUser, newline, '');
currentUser = split(currentUser, '\');
currentUser = currentUser{2};

for rIndex = 1:length(RepositoryPaths)
    disp(['Current: ', RepositoryPaths{rIndex}]);
    cd(RepositoryPaths{rIndex});
    system("git add .");

    if nargin < 1 || isempty(char(logstr))
        system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser, """"));
    else
        logstr = strrep(logstr, '"', '""');
        system(strcat("git commit -m """, logstr, """"));
    end

    system("git pull");

    if SyncOption
        system("git push");
    end

end

cd(currentPath);
return;
end