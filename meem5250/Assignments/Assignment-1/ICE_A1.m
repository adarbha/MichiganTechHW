clc
clear all
P_torr = 750;
P_bar = 1;
T_K = 298;
DG = [1.5 1.5 2.4 3.1 2.4 2.4 2.4 2.4 2.4 2.4 1.5 1.5];
VBD = [5.86 6.6 7.4 8.56 7.24 6.76 6.72 7.14 7.78 6.9 6.6 6.36];
figure
hold on
h_1 = plot(DG,VBD,'kd');
set(h_1,'markersize',1,'markerfacecolor','y');
VBD_corr1 = 3*DG;
h_2 = plot(DG,VBD_corr1,'-');
set(h_2,'linewidth',1,'markersize',1,'markerfacecolor',[1 0 0]);
f = ((293*P_torr)/(760*T_K)).*DG/10;
VBD_corr2 = 24.22*(f) + 6.08*sqrt(f);
h_3 = plot(DG,VBD_corr2,':');
set(h_3,'linewidth',1,'markerfacecolor',[0 1 0]);
VBD_corr3 = 4.3 + 136*(P_bar/T_K)+324*(P_bar/T_K).*DG;
h_4 = plot(DG,VBD_corr3,'--');
set(h_4,'linewidth',2)
p = polyfit(DG,VBD,2);
fit = polyval(p,DG);
% h_5 = plot(DG,fit,'.-');
% set(h_5,'linewidth',2)
grid on;
set(gca, 'fontname', 'Calibri', 'fontsize', 16);    
%     axis([0.5 3.5 0 5]);
xlabel('Gap {\it d_g } [mm]');
ylabel('Breakdown Voltage {\it V_{BD} } [kV]');
legend('Experimental Data','Thumb-rule','Paschens law','Pashely et al','data-fit(quadratic)', 4);
%Check for the fit
corr1_error = rms_error(VBD,VBD_corr1)
corr2_error = rms_error(VBD,VBD_corr2)
corr3_error = rms_error(VBD,VBD_corr3)
corr4_error = rms_error(VBD,fit)

figure
hold on
X = [0.4 1.4];
Y = [5 25];
p2 = plot(X,Y);
set(p2,'linewidth',2);
xtick = 0.3:0.2:0.5;
ytick = 5:5:32;
set(gca,'fontname','Calibri','fontsize',16,'XLim',[0.4 1.5],'XTick',[0.4 0.6 0.8 1.0 1.2 1.4 1.5]);
X_1 = [0.6 1.4];
Y_1 = [5.78 6.94];
X_2 = [0.6 1.4];
Y_2 = [18.70 37.3];
p3 = plot(X_1,Y_1,'kd');
p4 = plot(X_2,Y_2,'kd');
set(p3,'markersize',9,'markerfacecolor','y');
set(p4,'markersize',9,'markerfacecolor','g');
xlabel('Electrode gap(mm)');
ylabel('Ignition Voltage(kV)')
legend('Bosch correlation','40kPaa','200kPaa');
grid on


    