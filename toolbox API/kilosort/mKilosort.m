function mKilosort(binFullPath, ops, SAVEPATH)
% Description: Run kilosort with code
% Input:
%    - binFullPath: full path of *.bin
%    - ops: parameters for kilosort
%    - SAVEPATH: output folder path
% Example:
%     Th = [10, 6]; % specify Th
%     run('.\config\configFileRat.m'); % this returns ops
%     ops.Th = Th;
%     mKilosort(pwd, ops);

narginchk(2, 3);

if nargin < 3
    SAVEPATH = fileparts(binFullPath);
end

ops.fproc = fullfile(fileparts(binFullPath), 'temp_wh.dat'); % proc file on a fast SSD
ops.fbinary = binFullPath;

%% this block runs all the steps of the algorithm
if ~exist(fullfile(fileparts(binFullPath), 'wh_rez.mat'), "file")
    rez   = preprocessDataSub(ops);
    save(fullfile(fileparts(binFullPath), 'wh_rez.mat'), "rez");
else
    load(fullfile(fileparts(binFullPath), 'wh_rez.mat'));
end

try
    customInfo = evalin("base", "customInfo");
catch
    customInfo = [];
end

if getOr(customInfo, "reMerge", false)
    return
end
rez = datashift2(rez, 1);

[rez, st3, tF] = extract_spikes(rez);

rez = template_learning(rez, tF, st3);

[rez, st3, tF] = trackAndSort(rez);

rez = final_clustering(rez, tF, st3);

try
    rez = find_merges(rez, evalin("base", "customInfo.kilosortAutoMerge"));
catch
    rez = find_merges(rez, 1);
end

mkdir(SAVEPATH)
save(fullfile(SAVEPATH, "kiloRez.mat"), "rez", "-v7.3");
rezToPhy2(rez, SAVEPATH);

% cd(SAVEPATH);
% system('phy template-gui params.py');
end
