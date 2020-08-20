%% Battery Model
% B2 Parameters

clear all
close all
clc;

% Li-Ion SOC Curve from S.Hackney's Lecture Notes
B_SOC = 1-[  0   8  20  40  60    80   90   95    99 100]/100;
B_OCV =   [4.2 4.1 4.0 3.9 3.85 3.75 3.60 3.45  3.00   0];

[B_SOC, i] = sort(B_SOC);
B_OCV      = B_OCV(i);

%% Models are sentative to dV/dSOC so interpolate and smooth
BB_SOC = 0:0.001:1.0;
BB_OCV = interp1(B_SOC, B_OCV, BB_SOC);
% Filter
[b,a] = butter(1, 0.025);
BB_OCV = filtfilt(b,a, BB_OCV);
 
figure;
    h = plot(-B_SOC, B_OCV, 'bs-', -BB_SOC, BB_OCV, 'r.-');
    set(h, 'linewidth', 2, 'markerfacecolor', [1 1 0]);
    set(gca, 'fontname', 'Calibri');
    set(gca, 'fontsize', 16);
    axis([-1 0 3 4.5]);
   
    xlabel('-SOC (-)');
    ylabel('OCV (-)');
    grid on;
    
    legend('Extracted Data', 'Interpolated and Smoothed', 1);

%% Here use High resolution smoothed SOC/OCV
%B_SOC = BB_SOC;
%B_OCV = BB_OCV;
    
clear i h 