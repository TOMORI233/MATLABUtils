classdef PEOdd7_10Trial < oddball.oddballTrial
    properties
        freqSeq
    end

    methods
        function obj = PEOdd7_10Trial(trialNum, soundOnsetSeq, freqSeq, oddballType, firstPush, choiceWin)
            import oddball.oddballTypeEnum
            obj.trialNum = trialNum;
            obj.soundOnsetSeq = soundOnsetSeq;
            obj.freqSeq = freqSeq;
            obj.oddballType = oddballType;
            obj.firstPush = firstPush; % time from dev onset
            devOnset = soundOnsetSeq(end);

            if ~isequal(oddballType, oddballTypeEnum.INTERRUPT) ...
               && (isequal(obj.oddballType, oddballTypeEnum.DEV) && firstPush - devOnset >= choiceWin(1) && firstPush - devOnset <= choiceWin(2)) ...
               || (isequal(obj.oddballType, oddballTypeEnum.STD) && firstPush - devOnset > choiceWin(2))
                obj.correct = true;
            else
                obj.correct = false;
            end
        end

        function res = of(obj, type)
            switch type
                case "dev freq"
                    res = cellfun(@(x) x(end), {obj.freqSeq})';
                otherwise
                    res = oddball.oddballTrial.of(obj, type);
            end
        end
    end
end