function TDTmat2bin(data, STOREPATH, CHANNEL, FORMAT, SCALE_FACTOR)
    % Export Continuous Wave Data To Binary File

    %% Setup the variables for the data you want to extract
    % We will extract the stream stores and output them to 16-bit integer files
    % FORMAT = 'i16'; % i16 = 16-bit integer, f32 = 32-bit floating point
    % SCALE_FACTOR = 1e6; % scale factor for 16-bit integer conversion, so units are uV
    % Note: The recommended scale factor for f32 is 1

    narginchk(2, 5);

    if ~ischar(STOREPATH) && ~isa(class(STOREPATH), 'string')
        error('Please input correct STOREPATH');
    end

    % If STOREPATH does not exist, it will be created
    mkdir(STOREPATH);

    if nargin == 2
        CHANNEL = 1:size(data.streams.Wave.data, 1);
        FORMAT = 'i16';
        SCALE_FACTOR = 1e6;
    elseif nargin == 3
        FORMAT = 'i16';
        SCALE_FACTOR = 1e6;
    elseif nargin == 4
        SCALE_FACTOR = 1e6;
    end

    fs = data.streams.Wave.fs; % Hz

    mWaitbar = waitbar(0, 'Start');

    %%
    % Loop through all the streams and save them to disk in 10 second chunks
    fff = fields(data.streams);
    TIME_DELTA = 10;

    for ii = 1:numel(fff)

        if strcmp(fff{ii}, 'Wave')
            T1 = 0;
            T2 = T1 + TIME_DELTA;
            tIndex1 = floor(T1 * fs) + 1;
            tIndex2 = floor(T2 * fs) + 1;
            deltaIndex = tIndex2 - tIndex1;
    
            thisStore = fff{ii};
            OUTFILE = fullfile(STOREPATH, [thisStore '.bin']);
    
            fid = fopen(OUTFILE, 'wb');
    
            temp = data.streams.(thisStore).data(CHANNEL, tIndex1:tIndex2);
    
            % loop through data in 10 second increments
            while ~isempty(temp)
    
                if strcmpi(FORMAT, 'i16')
                    fwrite(fid, SCALE_FACTOR * reshape(temp, 1, []), 'integer*2');
                elseif strcmpi(FORMAT, 'f32')
                    fwrite(fid, SCALE_FACTOR * reshape(temp, 1, []), 'single');
                else
                    warning('Format %s not recognized. Use i16 or f32', FORMAT);
                    break;
                end

                waitbar((tIndex1 + deltaIndex)/size(data.streams.Wave.data, 2), mWaitbar, ['Exporting: ', num2str(tIndex1 + deltaIndex), '/', num2str(size(data.streams.Wave.data, 2))]);
    
                T1 = T2;
                T2 = T2 + TIME_DELTA;
                tIndex1 = floor(T1 * fs) + 1;
                tIndex2 = floor(T2 * fs) + 1;
    
                try
                    temp = data.streams.(thisStore).data(CHANNEL, tIndex1:tIndex2);
                catch
                    temp = [];
                end
    
            end
    
            waitbar(1, mWaitbar, 'Done');
            fprintf('Wrote %s to output file %s\n', thisStore, OUTFILE);
            fprintf('Sampling Rate: %.6f Hz\n', fs);
            fprintf('Num Channels: %d\n', length(CHANNEL));
            disp('Exporting to binary file Done!');
            fclose(fid);
            close(mWaitbar);
        end

    end

end
