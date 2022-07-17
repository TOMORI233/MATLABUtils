function [waveLength, MERGEPATH] = TDT2binMerge(BLOCKPATH, CHANNEL, FORMAT, SCALE_FACTOR)
%% Export Continuous Data To Binary File
%
%  Import continuous data into Matlab using TDTbin2mat
%  Export the data to a binary file (f32 floating point or 16-bit integer)
%  Channels are interlaced in the final output file
%  Good for exporting to other data analysis applications

%% Housekeeping
% Clear workspace and close existing figures. Add SDK directories to Matlab
% path.

%% Importing the Data
% This example assumes you downloaded our
% <https://www.tdt.com/files/examples/TDTExampleData.zip example data sets>
% and extracted it into the \TDTMatlabSDK\Examples\ directory. To import your own data, replace
% 'BLOCKPATH' with the path to your own data block.
%
% In Synapse, you can find the block path in the database. Go to Menu --> History.
% Find your block, then Right-Click --> Copy path to clipboard.

%% Setup the variables for the data you want to extract
% We will extract the stream stores and output them to 16-bit integer files
% FORMAT = 'i16'; % i16 = 16-bit integer, f32 = 32-bit floating point
% SCALE_FACTOR = 1e6; % scale factor for 16-bit integer conversion, so units are uV
% Note: The recommended scale factor for f32 is 1

narginchk(1, 4);

%%
% read the first second of data to get the channel count
% data = TDTbin2mat(BLOCKPATH, 'TYPE', {'streams'}, 'T2', 1);

%%
% If you want an individual store, use the 'STORE' filter like this:
if ~iscell(BLOCKPATH)
    BLOCKPATH = cellstr(BLOCKPATH);
end


blockName = regexpi(BLOCKPATH{1},'Block-\d+','match');
TANKPATH = erase(BLOCKPATH{1},blockName);
SAVEPATH = check_mkdir_SPR(TANKPATH,'Merge');
MERGEFILE = fullfile(SAVEPATH, 'Wave.bin');
fid2 = fopen(MERGEFILE, 'wb');

for blk = 1:length(BLOCKPATH)

    data = TDTbin2mat(BLOCKPATH{blk}, 'TYPE', {'streams'}, 'STORE', 'Wave', 'T2', 1);

    if nargin == 1
        CHANNEL = 1:size(data.streams.Wave.data, 1);
        FORMAT = 'i16';
        SCALE_FACTOR = 1e6;
    elseif nargin == 2
        FORMAT = 'i16';
        SCALE_FACTOR = 1e6;
    elseif nargin == 3
        SCALE_FACTOR = 1e6;
    end

    %%
    % Loop through all the streams and save them to disk in 10 second chunks
    fff = fields(data.streams);
    TIME_DELTA = 10;

    for ii = 1:numel(fff)
        T1 = 0;
        T2 = T1 + TIME_DELTA;

        thisStore = fff{ii};

        OUTFILE = fullfile(BLOCKPATH{blk}, [thisStore '.bin']);



        fid = fopen(OUTFILE, 'wb');

        data = TDTbin2mat(BLOCKPATH{blk}, 'STORE', fff{ii}, 'T1', T1, 'T2', T2);
        data.streams.Wave.data = data.streams.Wave.data(CHANNEL, :);
        loopN = 1;
        waveLength{blk}(loopN) = size(data.streams.Wave.data,2)/data.streams.Wave.fs;

        % loop through data in 10 second increments
        
        while ~isempty(data.streams.(thisStore).data)

            if strcmpi(FORMAT, 'i16')
                fwrite(fid, SCALE_FACTOR * reshape(data.streams.(thisStore).data, 1, []), 'integer*2');
                fwrite(fid2, SCALE_FACTOR * reshape(data.streams.(thisStore).data, 1, []), 'integer*2');
            elseif strcmpi(FORMAT, 'f32')
                fwrite(fid, SCALE_FACTOR * reshape(data.streams.(thisStore).data, 1, []), 'single');
                fwrite(fid2, SCALE_FACTOR * reshape(data.streams.(thisStore).data, 1, []), 'single');
            else
                warning('Format %s not recognized. Use i16 or f32', FORMAT);
                break;
            end

            T1 = T2;
            T2 = T2 + TIME_DELTA;

            try
                data = TDTbin2mat(BLOCKPATH{blk}, 'STORE', fff{ii}, 'T1', T1, 'T2', T2);
                data.streams.Wave.data = data.streams.Wave.data(CHANNEL, :);
                loopN = loopN + 1;
                waveLength{blk}(loopN) = size(data.streams.Wave.data,2)/data.streams.Wave.fs;
            catch
                data.streams.(thisStore).data = [];
            end

        end

        fprintf('Wrote %s to output file %s\n', thisStore, OUTFILE);
        fprintf('Sampling Rate: %.6f Hz\n', data.streams.(thisStore).fs);
        fprintf('Num Channels: %d\n', size(data.streams.(thisStore).data, 1));
        fclose(fid);

    end
end
fclose(fid2);
save([SAVEPATH '\mergePara.mat'],'waveLength','BLOCKPATH','SAVEPATH');

end
