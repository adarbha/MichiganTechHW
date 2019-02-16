%% Battery Model
% B2 Parameters

clear all
close all
clc;

B_SOC = 1-[  0   8  20  40  60    80   90   95    99 100]/100;
B_OCV =   [4.2 4.1 4.0 3.9 3.85 3.75 3.60 3.45  3.00   0];

[B_SOC, i] = sort(B_SOC);
B_OCV      = B_OCV(i);

figure;
    h = plot(-B_SOC, B_OCV, 'bs-');
    set(h, 'linewidth', 2, 'markerfacecolor', [1 1 0]);
    set(gca, 'fontname', 'Calibri');
    set(gca, 'fontsize', 16);
    axis([-1 0 3 4.5]);

    
    xlabel('-SOC (-)');
    ylabel('OCV (-)');
    grid on;

    
clear i h