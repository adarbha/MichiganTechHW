clear all;
clc;


%------------------------------PART-I-----------------------------------
%1a.Declaring arrays for time, velocity and slope

time_s = [0,13,145,148,160,165.5,180,183,300,350,390,493.6,500];
time_s_slope = [0,13,145,148,160,165.5,180,183,299,300,349,350,389,390,493.6,500]
vel_mph = [0,60,60,40,40,70,70,55,55,55,55,55,0];
slope_deg = [0,0,0,0,0,0,0,0,0,4,4,-4,-4,0,0,0];

%1b. Creating required variables in workspace

weight_sae = 4100;
density_sae = 0.00236;
Cd = 0.4;
g_sae = 32.17;
Area = 2.7;

%1c. Conversion into SI units

weight_N = 4.45*weight_sae;
g = 0.305*g_sae;
density = 16.018*density_sae;

%2. Plots for drive cycle

figure(1);
plot(time_s, vel_mph);
xlabel('Time in sec');
ylabel('Velocity in mph');
xlim([0 550]);
ylim([0 80]);

figure(2);
plot(time_s_slope, slope_deg);
xlabel('Time in sec');
ylabel('Slope in Deg');
ylim([-5 5]);


%------------------------------Part-II--------------------------------------

%1.Interpolation Step
%Interpolating the time interval

new_time = linspace(0,500,25000);
new_vel = interp1(time_s, vel_mph, new_time);
figure(3);
plot(new_time, new_vel);
xlabel('Time in sec');
ylabel('Velocity in mph');
new_slope = interp1(time_s_slope,slope_deg,new_time);
figure(4);
plot(new_time,new_slope);
xlabel('Time in sec');
ylabel('Slope in Deg');

%2.Calculating acceleration
vel_SI = new_vel*(1.6)*(5/18);
new_vel_accn = vel_SI;
new_vel_accn(25001) = 0;
time_accn = [new_time 500.02];

acceleration = diff(new_vel_accn)./diff(time_accn);
figure(5);
plot(new_time, acceleration);
xlabel('Time in sec');
ylabel('Acceleration in ms^{-2}')

%3.Calculating resistances and powers
roll_resistance = 0.01*weight_N*(1 + 0.01*new_vel);
drag = 0.5*Cd*density*Area*(vel_SI.^2);
gradient = weight_N.*sind(new_slope);

%Calculating tractive force by juggling around the forces and it turns out to be summation
%of performance and resistances

%Summing up resistances over the drive cycle

total_resistance = roll_resistance + drag + gradient;

%Calculating performance
performance = (weight_N./g)*acceleration;

%Calculating tractive force

tractive_force = performance + total_resistance;

%plots for forces

figure(6);
plot(new_time, roll_resistance);
xlabel('Time in secs');
ylabel('Rolling Resistance in N');

figure(7);
plot(new_time, drag);
xlabel('Time in secs');
ylabel('Drag force in N');


figure(8);
plot(new_time, tractive_force);
xlabel('Time in secs');
ylabel('Tractive force in N');

%Calculating power in W

roll_resistance_power = roll_resistance.*vel_SI;
drag_power = drag.*vel_SI;
tractive_power = tractive_force.*vel_SI;

%plots for power
figure(9);
plot(new_time, roll_resistance_power);
xlabel('Time in secs');
ylabel('Roll Resistance power in W');

figure(10);
plot(new_time, drag_power);
xlabel('Time in secs');
ylabel('Drag power in W');

figure(11);
plot(new_time, tractive_power);
xlabel('Time in secs');
ylabel('Tractive power in W');






