%Purge%
clc
clear all

%Sampling parameters%
Fs = 10000;

%Get data into work-space%
load('assignment_5_signals_update.mat')

% sptool
sig1_mat = reshape(signal_2(1:28672),4096,7);
hann_mat = reshape(flattopwin(28672),4096,7);
sig_1_mat_w = hann_mat.*sig1_mat;
sig1_fft = mean(fft_function(sig_1_mat_w),2);
freq_axis = linspace(0,1,length(sig1_fft))*(Fs/2);
plot(freq_axis,20*log10(abs(sig1_fft)))
xlabel('Frequency')
ylabel('Gain in dB')
grid