%MATLAB-SIMULATION
clc;
clear all;
close all;
Fs = 10240;
delta_t = 1/Fs;
T = 0.01;
N = ceil(T/delta_t);
delta_f = Fs/N;
% N = ceil(Fs*2/delta_f);

f1 = 1500;

A = 0.08;
t = (0:(N-1))*delta_t;
X = A*sin(2*pi*f1*t);
u = uencode(X,24);
d = udecode(u,24);
x = d;
w1 = hann(length(x))';
w2 = flattopwin(length(x))';
w3 = rectwin(length(x))';
x = w1.*x;
ACF = 1/mean(w1);
ECF = 1/rms(w2);
figure
% plot(x,'-x')
% NFFT = 2^nextpow2(N);
NFFT = N;
FFT = ECF*fft(x,NFFT)/NFFT;
FFT_f = Fs/2*linspace(0,1,NFFT/2);
hold on
p1 = plot(FFT_f,20*log10(2*abs(FFT(1:length(FFT)/2))./20e-06),'-r')


%LAB-DATA
dataat100 = csvread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-3\lab_3_data_at_1.csv');
x_actual = dataat100(1:103,2);
N_actual = 103;
hann_actual = hann(N_actual);
rect_actual = rectwin(N_actual);
flat_actual = flattopwin(N_actual);
x_actual = x_actual.*hann_actual;
ACF_actual = 1/mean(hann_actual);
ECF_actual = 1/rms(flat_actual);
FFT_actual = ACF_actual*fft(x_actual,N_actual)/N_actual;
FFT_f_actual = 10240/2*linspace(0,1,N_actual/2);
FFT_a_actual = 2*abs(FFT_actual(1:length(FFT_actual)/2));
p2 = plot(FFT_f_actual,(20*log10((FFT_a_actual)./20e-06)),'-g')
set(p1,'linewidth',2);
set(p2,'linewidth',2);
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
xlabel('Frequency(Hz)');
ylabel('log Amplitude in dB');
legend('Simulated','Actual')
grid
% subplot(3,1,1)
% plot(d)
% title('Simulated signal')
% grid on
% subplot(3,1,2)
% plot(d.*w1)
% title('Hanning window')
% grid on
% subplot(3,1,3)
% plot(d.*w2)
% title('Flattop window')
% grid on
% 
% figure
% p3 = plot(x_actual)
% set(p3,'linewidth',2)
% xlabel('Blocksize')
% ylabel('Volts V')
% grid
% figure
% stem(FFT_f,2*abs(FFT(1:length(x)/2)));
% xlabel('frequency')
% ylabel('Amplitude')
% grid


