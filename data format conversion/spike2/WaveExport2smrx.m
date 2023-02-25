function WaveExport2smrx(matPath, ch, savePath)
    narginchk(2, 3);

    [folderPath, matName, ~] = fileparts(matPath);

    if nargin == 2
        savePath = folderPath;
    end

    CEDS64LoadLib('D:\Education\Lab\monkey\Sort Tool\CEDS64ML');

    load(matPath);
    wave = data.streams.Wave.data(ch, :) * 1000;
    fs = data.streams.Wave.fs;

    %create smrx
    try
        mkdir(savePath);
    end
    
    fhand = CEDS64Create([savePath, '\', matName, '.smrx']);

    if (fhand <= 0)
        CEDS64ErrorMessage(fhand);
        unloadlibrary ceds64int;
        return;
    end

    % set file time base
    CEDS64TimeBase(fhand, 1 / fs);

    % create snip wave channel
    wavechan = CEDS64GetFreeChan(fhand);
    createret = CEDS64SetWaveChan(fhand, wavechan, 1, 9, fs);

    if createret ~= 0
        warning('realwave channel 1 not created correctly');
    end

    CEDS64ChanTitle(fhand, wavechan, 'AWave');
    CEDS64ChanComment(fhand, wavechan, 'snip Wave');
    CEDS64ChanUnits(fhand, wavechan, 'mV');

    % fill the RealWave channel
    sTime = CEDS64SecsToTicks(fhand, 0);
    fillret = CEDS64WriteWave(fhand, wavechan, wave, sTime);

    % read from the file
    maxTimeTicks = CEDS64MaxTime(fhand);
    maxTimeSecs = CEDS64TicksToSecs(fhand, maxTimeTicks);

    % close the file
    CEDS64CloseAll();
    % unload ceds64int.dll
    unloadlibrary ceds64int;

    return;
end
