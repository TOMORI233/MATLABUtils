function playAudio(y, varargin)
    % Play sound with PTB on a two-channel output device (default of system)
    %
    % playAudio(y, fsSound)
    % playAudio(y, fsSound, fsDevice)
    % playAudio(filepath)
    % playAudio(filepath, fsDevice)
    %
    % y is sound wave or sound file path
    % fsSound is samplerate of sound y. If y is sound wave, fsSound should not be empty
    % fsDevice is samplerate of output device (default: [])

    mIp = inputParser;
    mIp.addRequired("y", @(x) (isa(x, "double") && isvector(x)) || ischar(x) || isstring(x));
    mIp.addOptional("fs", [], @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    mIp.addOptional("fsDevice", [], @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    mIp.parse(y, varargin{:});

    switch class(y)
        case "double"
            fsSound = mIp.Results.fs;
            fsDevice = mIp.Results.fsDevice;

            if isempty(fsSound)
                error("fsSound should not be empty for sound wave input");
            end

        case "char"
            [y, fsSound] = audioread(y);
            fsDevice = mIp.Results.fs;
        case "string"
            [y, fsSound] = audioread(y);
            fsDevice = mIp.Results.fs;
        otherwise
            error("Invalid syntax");
    end

    [a, b] = size(y);

    if a > b
        y = y(:, 1)';
    else
        y = y(1, :);
    end
    
    if ~isempty(fsDevice) && ~isequal(fsSound, fsDevice)
        disp(['Resample from ', num2str(fsSound), ' Hz to device sample rate ', num2str(fsDevice), ' Hz']);
        y = resampleData(y, fsSound, fsDevice);
    end

    y = repmat(y, [2, 1]);

    %% Play Audio
    InitializePsychSound;
    PsychPortAudio('Close');

    deviceId = []; % use default device of system
    mode = 1; % playback only
    latencyClass = 2; % strict

    pahandle = PsychPortAudio('Open', deviceId, mode, latencyClass);
    PsychPortAudio('FillBuffer', pahandle, y);
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);
    PsychPortAudio('Close');
end