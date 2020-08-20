clc;
clear all;
close all;
%Sampling parameters
f = 179;
n = 31;
Fm = 13.1072*1e6;
Fs = ceil((Fm/256)/n);
delta_t = 1/Fs;
N = 64;
A = 1*sqrt(2);
T = N*delta_t;
t = (0:N-1)*delta_t;
x = A*sin(2*pi*f*t);
u = uencode(x,24,5);
x = udecode(u,24,5);
%Windows
w1 = hann(length(x))';
w2 = flattopwin(length(x))';
w3 = rectwin(length(x))';
ACF_1 = 1/mean(w1);
ACF_2 = 1/mean(w2);
ECF = 1/rms(w3);
x1 = x.*w1;
x2 = x.*w2;
figure
% p1=plot(t,x,'-x'); grid on
FFT = fft(x,N)/N;
FFT_1 = ACF_1*fft(x1,N)/N;
FFT_2 = ACF_2*fft(x2,N)/N;
FFT_f = Fs/2*linspace(0,1,N/2);
% figure
hold on
p1 = plot(FFT_f,(20*log10(abs(FFT(1:length(FFT)/2))./20e-06)),'-r'); 
p2 = plot(FFT_f,(20*log10(abs(FFT_1(1:length(FFT)/2))./20e-06)),'-b');
p3 = plot(FFT_f,(20*log10(abs(FFT_2(1:length(FFT)/2))./20e-06)),'-g');
grid on
set(p1,'linewidth',2);
set(p2,'linewidth',2);
set(p3,'linewidth',2);
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
xlabel('Frequency(Hz)');
ylabel('Amplitude in dB');
legend('Rectangular','Hanning','Flattop');
