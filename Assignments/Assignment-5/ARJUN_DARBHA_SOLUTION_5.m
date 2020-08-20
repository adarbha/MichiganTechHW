%Purge%
clc
clear all
close all

%Extracting data from matrices
test623 = load('TEST623.mat');
test626 = load('TEST626.mat');
test631 = load('TEST631.mat');

%Convert time from ms to s
test623.T = (test623.T)*1000;
test626.T = (test626.T)*1000;
test631.T = (test631.T)*1000;

%Engine design parameter
r_c = 10;
V_c = 6.47*1e-05;
R = 3.5;
CA_623 = test623.CA;
CA_626 = test626.CA;
CA_631 = test631.CA;



%Pressures referenced
P_R_623 = ref_press(CA_623,test623.P,test623.MAP,530,540);
P_R_626 = ref_press(CA_626,test626.P,test626.MAP,530,540);
P_R_631 = ref_press(CA_631,test631.P,test631.MAP,530,540);

[b a] = butter(3,0.25);
P_R_623_f = filtfilt(b,a,P_R_623);
P_R_631_f = filtfilt(b,a,P_R_631);
P_R_626_f = filtfilt(b,a,P_R_626);

%Desired plots
figure
hold on
plot(CA_623,P_R_623_f./100);
plot(CA_623,test623.MAP./100,'r');
set(gca,'fontname','Calibr','fontsize',20,'XTick',[-180:90:540])
legend('Cylinder','MAP');
xlabel('Engine position CAD')
ylabel('Pressure(bar)')

grid on
hold off

figure
hold on
plot(CA_626,P_R_626_f./100);
plot(CA_626,test626.MAP./100,'r');
set(gca,'fontname','Calibr','fontsize',20,'XTick',[-180:90:540])
legend('Cylinder','MAP');
xlabel('Engine position CAD')
ylabel('Pressure(bar)')

grid on
hold off

figure
hold on
plot(CA_631,P_R_631_f./100);
plot(CA_631,test631.MAP./100,'r');
set(gca,'fontname','Calibr','fontsize',20,'XTick',[-180:90:540])
legend('Cylinder','MAP');
xlabel('Engine position CAD')
ylabel('Pressure(bar)')

grid on
hold off

figure
CA_180 = abs(wrapTo180(CA_623));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
loglog(V_norm,P_R_623,V_norm,P_R_623_f,'r')
set(gca,'XMinorGrid','Off','fontname','Calibri','fontsize',20,'XLim',[(0.1-0.01) 1.015])
xlabel('Vol/Vol_(max)')
ylabel('Pressure(bar)')
legend('P(ref)','P(Ref & filt)')
grid


figure
CA_180 = abs(wrapTo180(CA_626));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
loglog(V_norm,P_R_626,V_norm,P_R_626_f,'r')
set(gca,'XMinorGrid','Off','fontname','Calibri','fontsize',20,'XLim',[(0.1-0.01) 1.015])
xlabel('Vol/Vol_(max)')
ylabel('Pressure(bar)')
legend('P(ref)','P(Ref & filt)')
grid

figure
CA_180 = abs(wrapTo180(CA_631));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
loglog(V_norm,P_R_631,V_norm,P_R_631_f,'r')
set(gca,'XMinorGrid','Off','fontname','Calibri','fontsize',20,'XLim',[(0.1-0.01) 1.015])
xlabel('Vol/Vol_(max)')
ylabel('Pressure(bar)')
legend('P(ref)','P(Ref & filt)')
grid


%Code for mean
%Test 623%
n_cyl = floor(length(CA_623)/720);
n = n_cyl*720;
i_start = min(find(CA_623<-179));
ii = (0:n-1) + i_start;

P_R_623_mat = reshape(P_R_623_f(ii), 720, n_cyl);
P_R_623_avg = mean(P_R_623_mat,2);
figure
hold on
plot(CA_623,P_R_623_f./100)
plot(linspace(-180,540,720),P_R_623_avg./100,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[-180 540])
xlabel('Engine Position CAD')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid on
hold off
figure
CA_180 = abs(wrapTo180(CA_623));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
CA_180_mean = abs(wrapTo180(linspace(-180,540,720)));
V_avg = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180_mean) - (R^2-sind(CA_180_mean).^2).^0.5));
V_avg_norm = V_avg./max(V_avg);
loglog(V_norm,P_R_623_f,V_avg_norm,P_R_623_avg,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[0.1-0.01 1+0.1],'XMinorGrid','Off')
xlabel('Vol/Vol_{max}')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid
%IMEP Calculations
W_623 = Work_cyc(P_R_623_avg,V_avg); %Net work
W_623_gross = Work_cyc(P_R_623_avg(1:360),V_avg(1:360)); %Gross work
W_623_mat = zeros(301,1);
V_mat = reshape(V(ii),720,301);
for i = 1:301
   W_623_mat(i,1) = Work_cyc(P_R_623_mat(1:360,i),V_mat(1:360,i));
end
IMEP_623 = W_623_mat./(5.82*1e-02);
COV_623=std(IMEP_623)/mean(IMEP_623); %Coefficient of variance
%Calculating gammas%
gamma_c_623 = polyfit(log(V_avg(1:180)),log(P_R_623_avg(1:180)'),1);
gamma_c_623(1)
gamma_e_623 = polyfit(log(V_avg(181:360)),log(P_R_623_avg(181:360)'),1);
gamma_e_623(1)


%Test 626%
n_cyl = floor(length(CA_626)/720);
n = n_cyl*720;
i_start = min(find(CA_626<-179));
ii = (0:n-1) + i_start;

P_R_626_mat = reshape(P_R_626_f(ii), 720, n_cyl);
P_R_626_avg = mean(P_R_626_mat,2);
figure
hold on
plot(CA_626,P_R_626_f./100)
plot(linspace(-180,540,720),P_R_626_avg./100,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[-180 540])
xlabel('Engine Position CAD')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid
hold off
figure
CA_180 = abs(wrapTo180(CA_626));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
CA_180_mean = abs(wrapTo180(linspace(-180,540,720)));
V_avg = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180_mean) - (R^2-sind(CA_180_mean).^2).^0.5));
V_avg_norm = V_avg./max(V_avg);
loglog(V_norm,P_R_626_f,V_avg_norm,P_R_626_avg,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[0.1-0.01 1+0.1],'XMinorGrid','Off')
xlabel('Vol/Vol_{max}')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid
%IMEP Calculations
W_626 = Work_cyc(P_R_626_avg,V_avg) %Net work
W_626_gross = Work_cyc(P_R_626_avg(1:360),V_avg(1:360)) %Gross work
W_626_mat = zeros(301,1);
V_mat = reshape(V(ii),720,301);
for i = 1:301
   W_626_mat(i,1) = Work_cyc(P_R_626_mat(1:360,i),V_mat(1:360,i));
end
IMEP_626 = W_626_mat./(5.82*1e-02);
COV_626=std(IMEP_626)/mean(IMEP_626) %coeffiecient of variance
%Calculating gammas%
gamma_c_626 = polyfit(log(V_avg(1:180)),log(P_R_626_avg(1:180)'),1);
gamma_c_626(1)
gamma_e_626 = polyfit(log(V_avg(181:360)),log(P_R_626_avg(181:360)'),1);
gamma_e_626(1)

%Test 631%
n_cyl = floor(length(CA_631)/720);
n = n_cyl*720;
i_start = min(find(CA_631<-179));
ii = (0:n-1) + i_start;
P_R_631_mat = reshape(P_R_631_f(ii), 720, n_cyl);
P_R_631_avg = mean(P_R_631_mat,2);
figure
hold on
plot(CA_631,P_R_631_f./100)
plot(linspace(-180,540,720),P_R_631_avg./100,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[-180 540])
xlabel('Engine Position CAD')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid
hold off
figure
CA_180 = abs(wrapTo180(CA_631));
V = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180) - (R^2-sind(CA_180).^2).^0.5));
V_norm = V./max(V);
CA_180_mean = abs(wrapTo180(linspace(-180,540,720)));
V_avg = V_c*(1 + 0.5*(r_c-1)*(R + 1 - cosd(CA_180_mean) - (R^2-sind(CA_180_mean).^2).^0.5));
V_avg_norm = V_avg./max(V_avg);
loglog(V_norm,P_R_631_f,V_avg_norm,P_R_631_avg,'r')
set(gca,'fontname','Calibri','fontsize',20,'XLim',[0.1-0.01 1+0.1],'XMinorGrid','Off')
xlabel('Vol/Vol_{max}')
ylabel('Pressure(bar)')
legend('Individual Cycle','Average Cycle')
grid
%IMEP calculations
W_631 = Work_cyc(P_R_631_avg,V_avg) %Net work
W_631_gross = Work_cyc(P_R_631_avg(1:360),V_avg(1:360)) %Gross work
W_631_mat = zeros(301,1);
V_mat = reshape(V(ii),720,301);
for i = 1:301
   W_631_mat(i,1) = Work_cyc(P_R_631_mat(1:360,i),V_mat(1:360,i));
end
IMEP_631 = W_631_mat./(5.82*1e-02);
COV_631=std(IMEP_631)/mean(IMEP_631) %Coeffiecient of variance
%Calculating gammas%
gamma_c_631 = polyfit(log(V_avg(1:180)),log(P_R_631_avg(1:180)'),1);
gamma_c_631(1)
gamma_e_631 = polyfit(log(V_avg(181:360)),log(P_R_631_avg(181:360)'),1);
gamma_e_631(1)

% % Define gamma (g)
% CA_TRANS = 4.5;
% N_TRANS  = 10;
% g = ones(size(CA_623));
% g(CA_623<CA_TRANS)  = 1.366;
% g(CA_623>=CA_TRANS) = 1.284;
% b = ones(1,N_TRANS);
% b = b/sum(b);
% g = filtfilt(b,1,g);
% clear b
% 
% g_avg = mean(reshape(g(ii),720,301),2);


















