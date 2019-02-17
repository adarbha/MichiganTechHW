data = csvread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-3\square_wave.csv');
% plot(data(:,1),data(:,2))
N = 1024;
Fs = 10240;
dt = 1/Fs;
FFT = fft(data(1:1024,2),1024)/1024;
FFT_f = Fs/2*linspace(0,1,N/2);
plot(FFT_f,2*abs(FFT(1:N/2)));