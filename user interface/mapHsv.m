function res = mapHsv(hsv255, rangeH, rangeS, rangeV)
    H = hsv255(1); % 0~180, int
    S = hsv255(2); % 0~255, int
    V = hsv255(3); % 0~255, int

    H0 = 0:180;
    H1 = mapminmax(H0, rangeH(1), rangeH(2));
    res(1) = H1(dsearchn(H0(:), H));

    S0 = 0:180;
    S1 = mapminmax(S0, rangeS(1), rangeS(2));
    res(2) = S1(dsearchn(S0(:), S));

    V0 = 0:180;
    V1 = mapminmax(V0, rangeV(1), rangeV(2));
    res(3) = V1(dsearchn(V0(:), V));

    return;
end