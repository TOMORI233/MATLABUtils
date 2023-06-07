ccc;
import oddball.*
import oddball.sub.*

A = oddballTypeEnum.STD;
A1 = oddballTypeEnum.STD.String;

B(1, 1) = PEOdd7_10Trial(1, [100, 110, 120, 130], [1000, 1000, 1000, 2000], oddball.oddballTypeEnum.DEV, 150, [0, 2000]);
B(2, 1) = PEOdd7_10Trial(2, [200, 210, 220, 230], [1000, 1000, 1000, 1000], oddball.oddballTypeEnum.DEV, 260, [0, 2000]);

B = B.setter("trialNum", 2 + [B.trialNum]);
C = obj2struct(B);
B1 = B.setter("oddballType", arrayfun(@(x) x.String, [B.oddballType]));
C1 = obj2struct(B1);

devFreqs = B1.of("dev freq");