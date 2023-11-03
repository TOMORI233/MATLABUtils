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
    rez = preprocessDataSub(ops);
    rez = datashift2(rez, 1);

    [rez, st3, tF] = extract_spikes(rez);

    rez = template_learning(rez, tF, st3);

    [rez, st3, tF] = trackAndSort(rez);

    rez = final_clustering(rez, tF, st3);

    rez = find_merges(rez, 1);

    mkdir(SAVEPATH)
    save(fullfile(SAVEPATH, "kiloRez.mat"), "rez", "-v7.3");
    rezToPhy2(rez, SAVEPATH);

    % cd(SAVEPATH);
    % system('phy template-gui params.py');
end
