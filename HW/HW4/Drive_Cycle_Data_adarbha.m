clear all;
clc;
% Un-named Student
 

 
Time = xlsread('Malibu_20100929_highway_Baseline','A:A');
 
Velocity_kph = xlsread('Malibu_20100929_highway_Baseline','B:B');%mps
 Velocity_mps = xlsread('Malibu_20100929_highway_Baseline','B:B')*1/3.6;


 
 %figure(1)
% plot(Time,Velocity_kph);
%title('velocity v/s time');
%xlabel('time(secs)');
%ylabel('velocity(kph)');

%figure(2)
 %plot(Time,Velocity_mps);
%title('velocity v/s time');
%xlabel('time(secs)');
%ylabel('velocity (m/s)');

weight_N = 16000;
Cd = 0.44;
density = 1.224;
Area = 2.7;

torque(1:1100) = 650;

for i = 1101:5000
    torque(i) = (9277.42-i)/12.58;
end

rpm = 1:5000;