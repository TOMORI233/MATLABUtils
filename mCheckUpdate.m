% Commit current work and check update for MATLABUtils
currentPath = pwd;
cd(fileparts(mfilename("fullpath")));
[~, currentUser] = system("whoami");
currentUser = split(currentUser, '\');

system("git add .");
system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser{1}, """"));
system("git pull origin master");

cd(currentPath);