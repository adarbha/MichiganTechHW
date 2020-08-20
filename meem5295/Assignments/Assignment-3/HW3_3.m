clc;
clear all;

mass_kg = 1590.91;
g = 9.8; %m/s^2

vel_mph = 0:0.1:70;
vel_mps = vel_mph*(1.6*1000/3600);
KE = (0.5*mass_kg).*(vel_mps.^2);

height_m = KE/(mass_kg*g);
height_ft = height_m*3.3;

figure(1)
plot(vel_mph,height_ft)
title('Velocity v/s Height')
xlabel('Velocty in m/s')
ylabel('Height in feet')


