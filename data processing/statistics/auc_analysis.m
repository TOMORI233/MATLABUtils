function AUC = auc_analysis(A, B)
    % Calculate ROC curves for each column of A and B
    [~, ~ ,~,auc] = perfcurve([ones(size(A,1),1);zeros(size(B,1),1)],[A;B],1);
    
    % Calculate AUC vector C
    AUC = zeros(size(A,2),1);
    for i = 1:size(A,2)
        AUC(i) = auc(i);
    end
end