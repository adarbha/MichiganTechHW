clear all;
clc;

weight_N = 16000;
L_m = 3.04; %wheel base in meters
L_a_m = 1.04; %distance of the front tire for CG
radius_wheel_m = 0.41; 
h_cg_m = 0.45; %height of cg from the ground
f_r = 0.016; %Rolling resistance coefficient
Cd = 0.44; %Drag coefficient
Area = 2.7;
density = 1.224; %density in kg per meter cubed
N_D = 3.08; %differential ratio
mu = 0.8; %coefficient of friction

%Drive cycle characteristics

M_number = [0 9 4 0 4 5 2 0 7];
vel_m_s = M_number*3;
vel_mph = vel_m_s*2.24;
time_scale = 0:8;
time_s = time_scale*100;


%E motor characteristics
%Torque versus rpm for the look up table

torque(1:1100) = 650;

for i = 1101:5000
    torque(i) = (-0.0949*i)+754.36;
end

rpm = 1:5000;

%Max braking force

decel_max = mu*9.81;


%Calculating beta(its been assumed that mu for the tire-road is a constant)

beta = ((mu*h_cg_m) + (L_m - L_a_m))/L_m;

%Malibu Drive Cycle

Time = xlsread('Malibu_20100929_highway_Baseline','A:A');
 
Velocity_kph = xlsread('Malibu_20100929_Highway_HW_9_10_2012','B:B');%mps
Velocity_mps = xlsread('Malibu_20100929_Highway_HW_9_10_2012','B:B')*1/3.6;




