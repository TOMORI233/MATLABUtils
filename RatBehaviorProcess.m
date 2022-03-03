function behavTrials = RatBehaviorProcess(path)
    load(path);
    behav = cell0.behav;

    %% behav
    lightOnsetTimeAll = behav.epocs.epocs.tril.onset;
    temp = 2:2:(fix(length(lightOnsetTimeAll)/2)*2);
    lightOnsetTimeAll = lightOnsetTimeAll(temp);
    
    soundOnsetTimeAll = behav.epocs.epocs.Stim.onset;
    soundOnsetTimeAll = soundOnsetTimeAll(1:length(lightOnsetTimeAll));

    spknAll = behav.epocs.epocs.spkn.data;
    spknAll = spknAll(temp);

    errorTrialIndex = behav.epocs.epocs.erro.data(behav.epocs.epocs.erro.data ~= 0);

    lickAll = behav.epocs.epocs.lick.data;
    lickTimeAll = behav.epocs.epocs.lick.onset;

    behavTrials = [];

    directionStr = ["L", "R"];

    for tIndex = 1:length(soundOnsetTimeAll)
        behavTrials(tIndex).trialNum = tIndex;
        behavTrials(tIndex).spkn = spknAll(tIndex);
        behavTrials(tIndex).trialOnset = soundOnsetTimeAll(tIndex);
        firstLickIndex = find(lickTimeAll > soundOnsetTimeAll(tIndex), 1);
        behavTrials(tIndex).lickDirection = directionStr(lickAll(firstLickIndex));
        behavTrials(tIndex).lickTime = lickTimeAll(firstLickIndex);

        if isempty(find(errorTrialIndex == tIndex, 1)) && behavTrials(tIndex).lickTime > lightOnsetTimeAll(tIndex)
            behavTrials(tIndex).interrupt = false;
        else
            behavTrials(tIndex).interrupt = true;
        end
    end

    behavTrials([behavTrials.interrupt] == true) = [];

    return;
end