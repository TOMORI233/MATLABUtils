function mCheckUpdate(logstr)
    % Commit current work and check update for MATLABUtils
    narginchk(0, 1);
    
    currentPath = pwd;
    cd(fileparts(mfilename("fullpath")));
    [~, currentUser] = system("whoami");
    currentUser = split(currentUser, '\');
    
    system("git add .");
    if nargin < 1
        system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser{1}, """"));
    else
        logstr = strrep(logstr, '"', '""');
        system(strcat("git commit -m """, logstr, """"));
    end
    system("git pull origin master");
    
    cd(currentPath);
    return;
end