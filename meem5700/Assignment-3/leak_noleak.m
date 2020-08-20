dataat100 = csvread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-3\lab_3_data_at_1.csv');
x_actual = dataat100(1:103,2);
N_actual = 103;
N_leak = 181;
x_leak = dataat100(1:181,2);
w1 = flattopwin(length(x_leak));
x_flat = w1.*x_leak;
ACF = 1/mean(w1);
FFT_actual = fft(x_actual,N_actual)/N_actual;
FFT_flat = ACF*fft(x_flat,length(x_flat))/length(x_flat);
FFT_f_actual = 10240/2*linspace(0,1,N_actual/2);
FFT_a_actual = 2*abs(FFT_actual(1:length(FFT_actual)/2));
FFT_a_flat = 2*abs(FFT_flat(1:length(FFT_flat)/2));
hold on
p1 = plot(FFT_f_actual,20*log10(FFT_a_actual./(20e-06)),'-g')
FFT_leak = fft(x_leak,N_leak)/N_leak;
FFT_f_leak = 10240/2*linspace(0,1,N_leak/2);
FFT_a_leak = 2*abs(FFT_leak(1:length(FFT_leak)/2));
p2 = plot(FFT_f_leak,20*log10(FFT_a_leak./(20e-06)),'-r')
p3 = plot(FFT_f_leak,20*log10(FFT_a_flat./20e-06),'-k')
set(p1,'linewidth',2);
set(p2,'linewidth',2);
set(p3,'linewidth',2);
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
xlabel('Frequency(Hz)');
ylabel('log Amplitude dB');
legend('no leak','leak(rectangular window)','flattop window')
grid