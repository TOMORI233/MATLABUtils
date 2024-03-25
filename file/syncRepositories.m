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

mIp = inputParser;
mIp.addRequired("logstr", @(x) isempty(x) || isStringScalar(x) || (ischar(x) && isStringScalar(string(x))));
mIp.addParameter("SyncOption", false, @(x) isscalar(x) && islogical(x));
mIp.addParameter("RepositoriesRootPath", [], @(x) isStringScalar(x) || (ischar(x) && isStringScalar(string(x))));
mIp.addParameter("RepositoryPaths", [], @(x) iscellstr(x) || isstring(x) || (ischar(x) && isStringScalar(string(x))));
mIp.parse(logstr, varargin{:});

SyncOption = mIp.Results.SyncOption;
RepositoriesRootPath = mIp.Results.RepositoriesRootPath;
RepositoryPaths = mIp.Results.RepositoryPaths;

currentPath = pwd;
[~, currentUser] = system("whoami");
currentUser = strrep(currentUser, newline, '');
currentUser = split(currentUser, '\');
currentUser = currentUser{2};

if isempty(RepositoryPaths)
    disp(['Searching for GIT repositories in: >> ', getAbsPath(RepositoriesRootPath), ' >>']);
    RepositoryPaths = dir(fullfile(RepositoriesRootPath, "**\.git\"));
    RepositoryPaths = unique({RepositoryPaths.folder})';

    if ~isempty(RepositoryPaths)
        RepositoryPaths = cellfun(@(x) getRootDirPath(x, 1), RepositoryPaths, "UniformOutput", false);
        disp('The following GIT repositories are found: ');
        cellfun(@disp, RepositoryPaths);
    else
        disp('No GIT repositories found in this directory.');
        disp('Check whether current directory is in a GIT repository...');
        RepositoryPaths = pwd;
    end

end

RepositoryPaths = cellstr(RepositoryPaths);

for rIndex = 1:length(RepositoryPaths)
    cd(RepositoryPaths{rIndex});
    [status, res] = system('git status');

    if status ~= 0
        disp('Current directory is not (in) a GIT repository.');
        continue;
    end

    disp(['Current repository: ', RepositoryPaths{rIndex}]);
    disp(res);

    if ~contains(res, 'nothing to commit, working tree clean')
        system("git add .");

        if nargin < 1 || isempty(char(logstr))
            system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser, """"));
        else
            logstr = strrep(logstr, '"', '""');
            system(strcat("git commit -m """, logstr, """"));
        end

    end

    system("git pull");

    if SyncOption
        system("git push");
    end

end

cd(currentPath);

return;
end