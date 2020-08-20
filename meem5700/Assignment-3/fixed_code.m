clc;
clear all;
dataat100 = csvread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-3\lab_3_data_at_1.csv');

fft_new = fft_function(dataat100(1:11266,2));
fft_new_leak = fft_function(dataat100(1:5634,2));
FFT_f = (10240/2)*linspace(0,1,5633);
FFT_f_leak = (10240/2)*linspace(0,1,2817);
hold on
plot(FFT_f,20*log10(abs(fft_new)/20e-06));
plot(FFT_f_leak,20*log10(abs(fft_new_leak)/20e-06),'r');
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
xlabel('Frequency(Hz)');
ylabel('log Amplitude dB');
legend('no-leak','leak')
grid
