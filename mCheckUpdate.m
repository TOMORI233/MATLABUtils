function mCheckUpdate(logstr, syncOpt)
    % Commit current work and check update for MATLABUtils
    narginchk(0, 2);

    if nargin < 2
        syncOpt = false;
    end
    
    currentPath = pwd;
    cd(fileparts(mfilename("fullpath")));
    [~, currentUser] = system("whoami");
    currentUser = split(currentUser, '\');
    
    system("git add .");

    if nargin < 1 || isempty(char(logstr))
        system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser{1}, """"));
    else
        logstr = strrep(logstr, '"', '""');
        system(strcat("git commit -m """, logstr, """"));
    end

    system("git pull origin master");

    if syncOpt
        system("git push origin master");
    end
    
    cd(currentPath);
    return;
end