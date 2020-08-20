%Oscilloscope data
odata_low = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\Oscilloscope data.xlsx',1);
odata_high = xlsread('C:\Accost\Mich Tech\Course work\Dynamic Systems and measurements\Lab Assignments\Assignment-4\Oscilloscope data.xlsx',2);

%Extracting parameters of interest
frequency_low = odata_low(:,1);
gain_low = 20*log10(odata_low(:,2)./20e-06);
phase_low = (odata_low(:,3));

frequency_high = (odata_high(:,1));
gain_high = 20*log10(odata_high(:,2)./20e-06);
phase_high = odata_high(:,3);



%% Phase plots
% for i=1:length(phase_low)
%     if phase_low(i) < -180
%         phase_low(i) = 360 + phase_low(i);
%     elseif phase_low(i) > 180
%         phase_low(i) = phase_low(i) - 360;
%     end
% end
%     
% 
% for i=1:length(phase_low)
%     if phase_high(i) < -180
%         phase_high(i) = 360 + phase_high(i);
%     elseif phase_high(i) > 180
%         phase_high(i) = phase_high(i) - 360;
%     end
% end

% hold on
% ph1 = plot(frequency_low,-phase_low,'-bo','MarkerFaceColor','r','MarkerSize',8);
% ph2 = plot(frequency_high,-phase_high,'-ro','MarkerSize',8);
% set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
% set(ph1,'linewidth',2)
% set(ph2,'linewidth',2)
% xlabel('Frequency(Hz)')
% ylabel('Phase angle in degrees')
% legend('low tone','high tone')
% grid

%% Gains plot


% 
hold on
p1 = plot(frequency_low,gain_low,'-bo','MarkerFaceColor','r','MarkerSize',8);
p2 = plot(frequency_high, gain_high,'-ro','MarkerSize',8);
set(gca, 'fontname', 'Calibri', 'fontsize', 16); 
set(p1,'linewidth',2)
set(p2,'linewidth',2)
xlabel('Frequency(Hz)')
ylabel('Gain(Vout/Vin) in dB')
legend('low tone','high tone')
grid



