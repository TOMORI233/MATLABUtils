classdef oddballTrial
    properties % All in ms
        trialNum
        soundOnsetSeq
        oddballType
        firstPush
        correct
    end

    methods (Static)
        function res = of(obj, type)
            switch type
                case "trial onset"
                    res = cellfun(@(x) x(1), {obj.soundOnsetSeq})';
                case "dev onset"
                    res = cellfun(@(x) x(end), {obj.soundOnsetSeq})';
                case "push onset"
                    res = vertcat(obj.firstPush);
                case "ISI"
                    res = mode(arrayfun(@(x) (x.soundOnsetSeq(end) - x.soundOnsetSeq(1)) / (length(x.soundOnsetSeq) - 1), obj));
                case "DEV"
                    res = arrayfun(@(x) isequal(x, oddball.oddballTypeEnum.DEV), [obj.oddballType])';
                case "STD"
                    res = arrayfun(@(x) isequal(x, oddball.oddballTypeEnum.STD), [obj.oddballType])';
                case "INTERRUPT"
                    res = arrayfun(@(x) isequal(x, oddball.oddballTypeEnum.INTERRUPT), [obj.oddballType])';
                case "correct"
                    res = vertcat(obj.correct);
                case "wrong"
                    res = (~[obj.correct] & ~arrayfun(@(x) isequal(x, oddball.oddballTypeEnum.INTERRUPT), [obj.oddballType]))';
                case "stdNum"
                    res = cellfun(@(x) length(x) - 1, {obj.soundOnsetSeq})';
            end
        end
    end
end