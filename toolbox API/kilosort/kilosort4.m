function kilosort4(settings, opts)
% run kilosort4 in MATLAB via python API

% json convertion
settings_json = jsonencode(settings);
opts_json = jsonencode(opts);

% export json to temp files
settings_file = [tempname, '_settings.json'];
opts_file = [tempname, '_opts.json'];
fid = fopen(settings_file, 'w'); fwrite(fid, settings_json); fclose(fid);
fid = fopen(opts_file, 'w'); fwrite(fid, opts_json); fclose(fid);

% python interpreter
pythonExe = 'D:\Environment\anaconda3\envs\kilosort\python.exe';

% python API
pyScript = fullfile(fileparts(mfilename("fullpath")), 'kilosort4_wrapper.py');

% construct command line script
cmd = sprintf('"%s" "%s" "%s" "%s"', pythonExe, pyScript, settings_file, opts_file);

% run python script via command line
[status, cmdout] = system(cmd);

% clear temp files
delete(settings_file);
delete(opts_file);

if status ~= 0
    error('Python script execution failed:\n%s', cmdout);
end

end
