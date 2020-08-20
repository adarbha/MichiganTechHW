%Purge and clean
clc;
clear all;

radius_w =0.3175; %meters
vel_mph_w = 30;
vel_ms_w = 13.4112;

%Power function

omega_rpm = linspace(1500,6000);
rpm2rds = 2*pi/60;
omega_rad = omega_rpm*rpm2rds;

% omega_rad = 450:600;

P_kw = 0.07*(omega_rad) + 1.3e-4*(omega_rad.^2) - 2.4e-7*(omega_rad.^3);

% plot(omega_rad,P_kw)

%Calculating max power
p = polyfit(omega_rad,P_kw,3);
% plot(omega_rad,P_kw,omega_rad,polyval(p,omega_rad),'*')
dp = polyder(p);
r = roots(dp);
P_kw_max = polyval(p,r(1));
P_W_max = P_kw_max*1e3;
e_torque_max = engine_torque(r(1),1);

% 
Ntf = (P_W_max*radius_w)/(e_torque_max*vel_ms_w);
% 
omega_wheel = omega_rad/Ntf;
% 
vel_ms = omega_wheel*radius_w;
% 
vel_mph = vel_ms*2.25;
% 
e_torque = engine_torque(omega_rad,1);
% 
% % plot(vel_ms,P_kw_max*1000./(vel_ms.^2))
hold on
plot(vel_mph,e_torque*Ntf/radius_w)
plot(vel_mph,P_W_max./vel_ms,'-r')
title('Tractive force v/s mph')
ylabel('TeNtf/R')
xlabel('mph')
hold off






