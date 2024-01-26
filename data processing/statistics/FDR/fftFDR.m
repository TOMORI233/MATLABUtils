function pAdj = fftFDR(FFTData, fFFT, pCrit, fcNbrN)
% INPUT:
    % FFTData: n*m array, where m equals length of frequency of FFT and n equals sample length
    % fFFT:    frequency of FFT
    % fcNbrN:  size of nerghboring bins of the certain frequency, so that
    %          the sample size of fc is 1+2*fcNbrN, and the nerbouring frequency 
    %          bins is set [-3*fcNbrN-1, -fcNbrN-1] and [fcNbrN+1, 3*fcNbrN+1]. 
% OUTPUT:
    % pAdj: m*2 array, first column equals to fFFT, 2nd column refers to corrected p value of one tail ttest
    narginchk(2, 4);
    if nargin < 4
        fcNbrN = 1;
    end
    if nargin < 3
        pCrit = .05;
    end
    
    fcIdx  = (3*fcNbrN+2:1:length(fFFT)-1-3*fcNbrN)' + (-fcNbrN:fcNbrN);
    nbrIdx = fcIdx + [-3*fcNbrN-1:-fcNbrN-1, fcNbrN+1:3*fcNbrN+1];
    fcAmp = cell2mat(cellfun(@(x) mean(FFTData(:, x), 2), num2cell(fcIdx, 2), "UniformOutput", false)');
    nbrAmp = cell2mat(cellfun(@(x) mean(FFTData(:, x), 2), num2cell(nbrIdx, 2), "UniformOutput", false)');
    [~, p] = ttest(fcAmp, nbrAmp, "Tail", "right");
    [~, ~, ~, adj_p]=fdr_bh(p,pCrit,'pdep','no');
    pAdj = [reshape(fFFT(fcIdx), [], 1), adj_p'];

end