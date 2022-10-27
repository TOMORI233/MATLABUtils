function playAudio(y, fs)
    % y is a vector
    InitializePsychSound;
    PsychPortAudio('Close');
    pahandle = PsychPortAudio('Open', [], 1, 2, fs, 2);
    PsychPortAudio('FillBuffer', pahandle, repmat(reshape(y, [1, length(y)]), 2, 1));
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);
    PsychPortAudio('Close');
end