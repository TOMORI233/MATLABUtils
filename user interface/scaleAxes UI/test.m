ccc;

fs = 1e3;
t = 0:1/fs:2;
Fig = figure;
mSubplot(2,1,1);
plot(t, sin(2*pi*t));
mSubplot(2,1,2);
plot(t, 2*sin(pi*t));

scaleAxes(Fig, "uiOpt", "show");