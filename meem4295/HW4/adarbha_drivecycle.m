%the range of this drive cycle is 800 sec.
clear all
clc

M_number = [0 9 4 2 4 5 2 0 7];
vel_m_s = M_number*3;
vel_mph = vel_m_s*2.24;
time_scale = 0:8;
time_s = time_scale*100;

weight_N = 16000;
Cd = 0.44;
density = 1.224;
Area = 2.7;

torque(1:1100) = 650;

for i = 1101:5000
    torque(i) = (9277.42-i)/12.58;
end

rpm = 1:5000;


%Malibu Drive Cycle

Time = xlsread('Malibu_20100929_highway_Baseline','A:A');
 
Velocity_kph = xlsread('Malibu_20100929_highway_Baseline','B:B');%mps
Velocity_mps = xlsread('Malibu_20100929_highway_Baseline','B:B')*1/3.6;

figure(2)
plot(rpm,torque)