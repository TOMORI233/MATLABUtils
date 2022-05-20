function mGenerateVmrk(BLOCKPATH,data,dataName,sampleRate,markerFile)
% dataName = 'Lfp1.bin';
fid = fopen(fullfile(BLOCKPATH,markerFile), 'w');

vmrkString1 = ['Brain Vision Data Exchange Marker File, Version 1.0 \r\n\r\n' ...
    '[Common Infos]\r\n'...
    'Codepage=UTF-8\r\n'];

vmrkString2 = ['DataFile=' dataName '\r\n\r\n'];

vmrkString3 = ['[Marker Infos]\r\n'...
'; Each entry: Mk<Marker number>=<Type>,<Description>,<Position in data points>,\r\n'...
'; <Size in data points>, <Channel number (0 = marker is related to all channels)>\r\n'...
'; Fields are delimited by commas, some fields might be omitted (empty).\r\n'...
'; Commas in type or description text are coded as "\\1".\r\n'];

vmrkString4 = 'Mk1=New Segment,,1,1,0,20081222112032984238\r\n';

vmrkString5 = epocsToVmrk(data,sampleRate);

vmrkOutput = [vmrkString1 vmrkString2 vmrkString3 vmrkString4 vmrkString5];
fprintf(fid,vmrkOutput);
fclose(fid);
