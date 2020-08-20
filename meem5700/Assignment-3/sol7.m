clc;
clear all;
close all;
%Sampling parameters
Fs = 10240;
delta_t = 1/Fs;
data = csvread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-3\square_wave.csv');
time_history = data(:,2); 
N = 1024; %Block-size
N_total = length(time_history); %Total number of points
x = time_history;

T_total = N_total*delta_t; %Total time of measurement
X=x;
count = 1;

for i=1:N:N_total-1024
    i;
    block = i+1023;
    u = uencode(X(i:i+1023),24);
    d = udecode(u,24);
    x = d;
    w2 = hann(length(x));
    w1 = flattopwin(length(x));
    x1 = w2.*x;
    x2 = w1.*x;
    ACF_1 = 1/mean(w2);
    ACF_2 = 1/mean(w1)
    FFT_1 = ACF_1*fft(x1,length(x1))/length(x1);
    FFT_2 = ACF_2*fft(x2,length(x2))/length(x2);
    FFT = fft(x,length(x))/length(x);
    block_spectrum_1(count,:)=(2*abs(FFT_1(1:length(FFT_1)/2))); %Store each spectrum as a row
    block_spectrum_2(count,:)=(2*abs(FFT_2(1:length(FFT_2)/2)));
    block_spectrum_3(count,:)=(2*abs(FFT(1:length(FFT)/2)));
    count = count+1;
end

freq = Fs/2*(linspace(0,1,N/2));

%Calculating block averages
block_average_1 = mean(block_spectrum_1(1:41,:),1); %Consider first 50-blocks only
block_average_2 = mean(block_spectrum_2(1:41,:),1);
block_average_3 = mean(block_spectrum_3(1:41,:),1);

%Plots
hold on
p1 = plot(block_average_1,'-r')
p2 = plot(block_average_2,'-g')
p3 = plot(block_average_3,'-b')
xlabel('frequency(Hz)')
ylabel('Volts V')
legend('Hanning','Flattop','Rectangular')
grid


