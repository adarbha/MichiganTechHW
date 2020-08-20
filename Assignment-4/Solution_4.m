%Clean and purge%
clc;
clear all;

%Data extraction step%
voltage_source = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\time history high.xls',1);
voltage_response = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\time history high.xls',2);

%Creating the matrices
source_mat = reshape(voltage_source(1:61440,2),2048,30);
res_mat = reshape(voltage_response(1:61440,2),2048,30);

%Applying windows
hanning_mat = repmat(hann(2048),1,30);
ACF = 1/mean(hanning_mat(:,1));
ECF = 1/rms(hanning_mat(:,1));
source_mat_w = source_mat.*hanning_mat;
res_mat_w = res_mat.*hanning_mat;

%Performing ffts on the matrices%
source_fft = fft_function(source_mat_w);
res_fft = fft_function(res_mat_w);

auto_source = mean((conj(source_fft).*source_fft),2);
auto_res = mean((conj(res_fft).*res_fft),2);

cross_response_source = mean((((conj(res_fft).*source_fft))),2);
cross_source_response = mean((((conj(source_fft).*res_fft))),2);

coherence = (cross_source_response.*cross_response_source)./(auto_source.*auto_res);

H1 = cross_source_response./auto_source;
H2 = auto_res./cross_response_source;
frequency_axis = (51200/2)*linspace(0,1,2048/2);
% 
% hold on
% 
% 
% plot(frequency_axis,20*log10(abs(H1)));
% plot(frequency_axis,20*log10(abs(H2)),'-g');
% plot(frequency_axis,coherence,'r');
% frf plots
% frf_high = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\frf high.xls');
% frf_low = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\low tone 13 oct\frf low.xlsx');
% hold on
% subplot(2,1,1)
% pl1 = plot(frequency_axis,(10.^(0.05*frf_high(:,2))),'r');
% pl2 = plot(frequency_axis,((frf_low(:,2))),'r');
% legend('frf high-tone','frf low tone')

% set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
% set(pl1,'linewidth',2)
% set(pl2,'linewidth',2)
% xlabel('Frequency(Hz)')
% ylabel('Magnitude (Vout/Vin)')
% legend('H1','H2','NI')
% grid
% 
% % Phase plots
% 
% phase_high = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\phase high.xls');
phase_low = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\low tone 13 oct\phase.xlsx');
% 
hold on
% pl1 = plot(phase_high(:,1),(phase_high(:,2)));
pl2 = plot(phase_low(:,1),(phase_low(:,2)),'r');
% legend('phase high-tone','phase low tone')
% 
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
% set(pl1,'linewidth',2)
set(pl2,'linewidth',2)
xlabel('Frequency(Hz)')
ylabel('Phase in degrees')
% legend('low tone','high tone')
% grid
% 
% % Coherence plots
% 
% coherence_high = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\coherence high.xls');
% coherence_low = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\low tone 13 oct\coherence low.xlsx');
% 
% hold on
% subplot(2,1,2)
% co1 = plot(frequency_axis,(coherence_high(:,2)));
% co2 = plot(frequency_axis,(coherence_low(:,2)),'b');
% legend('phase high-tone','phase low tone')
% 
% set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
% set(co1,'linewidth',2)
% set(co2,'linewidth',2)
% xlabel('Frequency(Hz)')
% ylabel('Magnitude')
% legend('Matlab','NI')
% grid
% 
% 
% legend('H1','H2','NI')
% 
% 
% coherence_actual = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\high tone 13 oct\coherence high.xls');
% plot(frequency_axis,(coherence),'-r')
% plot(frequency_axis,(coherence_actual(:,2)))
% 
frf_actual = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\phase_darbha.xlsx');
f_act = plot(frf_actual(:,1),frf_actual(:,2));
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
% set(pl1,'linewidth',2)
set(f_act,'linewidth',2)
% xlabel('Frequency(Hz)')
% ylabel('Magnitude (Vout/Vin) in dB')
legend('Low-tone','Amplifier only')
grid
