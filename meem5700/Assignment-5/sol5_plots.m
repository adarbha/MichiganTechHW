close all

%First signal%

%Actual signal%
% signal = sig1.data(1:1000);
% figure
% plot((1:1000)*(1/Fs),signal);
% xlabel('Time (s)')
% ylabel('Amplitude')
% grid


%Filtered signals
signal_f_1 = sig7.data(5000:6000);
signal_f_2 = sig10.data(5000:6000);
signal_f_3 = sig18.data(5000:6000);
signal_f_4 = sig19.data(5000:6000);
signal_f_5 = sig20.data(5000:6000);


figure
hold on
plot((1:1001)*(1/Fs),signal_f_1,'r')
plot((1:1001)*(1/Fs),signal_f_2,'g')
plot((1:1001)*(1/Fs),signal_f_3,'k')
plot((1:1001)*(1/Fs),signal_f_4,'m')
plot((1:1001)*(1/Fs),signal_f_5)
hold off
legend('Square wave(160Hz) harmonic','Square (50Hz)','Inharmonic(160Hz)','Sine(20Hz)','Sine(180Hz)');
% legend('Sine wave(340Hz)','Square wave(100Hz)') 
xlabel('Time (s)')
ylabel('Amplitude')
grid
%Filters
% filt_1 = filt1.


%Spectra
% plot_spect(spect1)
% plot_spect(spect2)
% plot_spect(spect3)

