clear; clc; close all;

fs = 1e3;
t = 0:1/fs:2;
Fig = figure;
plot(t, sin(2*pi*t));

scaleAxes(Fig, "uiOpt", "show");