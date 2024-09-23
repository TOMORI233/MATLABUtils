function mat2bin(data, FILEPATH)
    % [data] should be [nch, nsample]
    % Exported *.bin contains int16 data. Make sure [data] are scaled.
    % [FILEPATH] is full bin file path.

    % convert to int16
    data = int16(data);

    % write to bin file
    fid = fopen(FILEPATH, 'wb');
    fwrite(fid, data(:), 'integer*2');
    fclose(fid);

    return;
end