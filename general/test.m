clear; clc;

img = imread('C:\Users\TOMORI\Pictures\Saved Pictures\peko2.jpg');
A = double(rgb2gray(img));

%% SVD
th1 = 0.8;
[U1, S1, V1] = svd(A);
for index = 1:min([size(S1, 1), size(S1, 2)])
    if sum(S1(:, 1:index), 'all') / sum(S1, 'all') > th1
        k1 = index;
        break;
    end
end
S1(k1 + 1:end, :) = 0;
A_rec1 = U1 * S1 * V1';

%% PCA
th2 = 1;
[~, ~, k2] = mPCA(A, th2);
[~, A_rec2] = pcares(A, k1);

%% Plot
Fig = figure;
maximizeFig(Fig);
mSubplot(Fig, 2, 2, 1, [1, 1], [0.1, 0.1, 0.1, 0.1]);
imshow(img);
title('original');
mSubplot(Fig, 2, 2, 2, [1, 1], [0.1, 0.1, 0.1, 0.1]);
imshow(A / 255);
title('gray');
mSubplot(Fig, 2, 2, 3, [1, 1], [0.1, 0.1, 0.1, 0.1]);
imshow(A_rec1 / 255);
title(['SVD reconstruction (', num2str(th1 * 100), '% reserved)']);
mSubplot(Fig, 2, 2, 4, [1, 1], [0.1, 0.1, 0.1, 0.1]);
imshow(A_rec2 / 255);
title(['PCA reconstruction (', num2str(th2 * 100), '% reserved)']);