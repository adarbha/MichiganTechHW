function [ dv ] = velocity( t, vel )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dv = zeros(2,1);

v = vel(1);
x = vel(2);

%Parameters
M = 2500; %lbs
rho = 0.00236; %slugs/ft^3
Cd = 0.32;
A = 20; %ft^2
slope = 0.02; %2% slope given
theta = atan(slope);
fo = 0.010; %for 30psi
fs = 0.005; %for 30psi
inertia_e = 0.8; %in-lb-sec^2
inertia_t = 0.5; %in-lb-sec^2 for fourth gear
inertia_d = 1.2; %in-lb-sec^2 final drive
inertia_w = 11; %in-lb-sec^2 each wheel
Ntf = 1.36; %for the fourth gear
Nf = 2.92; %final drive ratio
radius_w = 12.59; %wheel radius in inches
radius_w_ft = radius_w/12;
omega_wheel = v/radius_w_ft;
eff = 0.97380*99; %fourth gear efficiency times final drive efficiency

inertia_eff = (inertia_e+inertia_t)*(Ntf^2) + inertia_d*(Nf^2) + 4*inertia_w;
mass_eff = inertia_eff/((radius_w)^2);

total_mass = (M + mass_eff);

%curve-fitting functions for engine torque
rpm2rds=2*pi/60;
omega = (800:400:5200)*rpm2rds; %RPM
torque = [120 132 145 160 175 181 190 198 200 201 198 180]; %ft-lb


torque_coeff=polyfit(omega,torque,2);

torque_engine = polyval(torque_coeff,omega_wheel*Ntf*Nf);

%resistances
grade = M*sin(theta)*32;
drag = 0.5*rho*Cd*A*(v.^2);
roll_resistance = fo + 3.24*fs*((v*0.68/100).^(2.5));

dv(1) = ((torque_engine*eff*Ntf*Nf/radius_w_ft) - grade - drag - (roll_resistance)*M*32*cos(theta))/total_mass;

dv(2) = v;
end

