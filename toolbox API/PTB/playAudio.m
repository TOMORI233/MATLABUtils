function playAudio(y, fs, fsDevice)
    % y is a vector
    % fs is samplerate of sound y

    narginchk(2, 3);

    if nargin < 3
        fsDevice = fs;
    end

    y = reshape(y, [1, length(y)]);
    
    if fs ~= fsDevice
        y = resampleData(reshape(y, [1, length(y)]), fs, fsDevice);
    end

    InitializePsychSound;
    PsychPortAudio('Close');
    pahandle = PsychPortAudio('Open', [], 1, 2, fsDevice, 2);
    PsychPortAudio('FillBuffer', pahandle, repmat(y, 2, 1));
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);
    PsychPortAudio('Close');
end