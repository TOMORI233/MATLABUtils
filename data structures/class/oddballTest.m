ccc;
import oddball.*
import oddball.sub.*

A = oddballTypeEnum.STD;
A1 = oddballTypeEnum.STD.String;

B(1) = PEOdd7_10Trial(1, [100, 110, 120, 130], [1000, 1000, 1000, 2000], oddball.oddballTypeEnum.DEV, [], [0, 2000]);
B(2) = PEOdd7_10Trial(2, [200, 210, 220, 230], [1000, 1000, 1000, 1000], oddball.oddballTypeEnum.DEV, 260, [0, 2000]);

% for non-static method, the result should be reassigned to B
B = B.setter("trialNum", 2 + [B.trialNum]);
C = obj2struct(B);
C1 = arrayfun(@(x) struct(x), B); % use built-in function struct(obj), where obj is scalar
isequal(C1, C) % true

% oddballType should be oddball.oddballTypeEnum
B1 = B.setter("oddballType", arrayfun(@(x) x.String, [B.oddballType]));
isequal(B1, B) % true, assignment failed
B1(1) = B1(1).setter("oddballType", oddball.oddballTypeEnum.INTERRUPT);
isequal(B1, B) % false, assignment success

devFreqs = B1.of("dev freq");