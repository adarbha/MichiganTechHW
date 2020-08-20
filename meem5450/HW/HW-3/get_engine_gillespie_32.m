%Gillespie Data Page32
clear  all
format short e
format compact
rpm2rds=2*pi/60;

omega_data= [800 1200 1600 2000 2400 2800 3200 3600 4000 4400 4800 5200]*rpm2rds;
torque_data=[120 132  145  160  175  181 190  198  200  201  198  180];
power_data=omega_data.*torque_data;
omega_max_power=4800*rpm2rds
power_max=180*5200*rpm2rds;
power_max_hp=power_max/550
omega_max_torque=4400*rpm2rds
torque_max=201

torque_coeff=polyfit(omega_data,torque_data,2)


P1=0.6*power_max/omega_max_power;
P2=1.4*power_max/omega_max_power^2;
P3=-power_max/omega_max_power^3;
P0=0.0;
torque_coeff_a=[P3,P2,P1]
power_coeff_a=[P3,P2,P1,P0]

p=polyder(torque_coeff);
temp=roots(p);
omega_max_torque=temp(1)
torque_max_1=polyval(torque_coeff,omega_max_torque)

p=polyder([torque_coeff,0]);
temp=roots(p);
omega_max_power_1=temp(1)
power_max_1_hp=polyval([torque_coeff,0],omega_max_power_1)/550

p=polyder(torque_coeff_a)
temp=roots(p);
omega_max_torque_a=roots(1)
torque_max_a=polyval(torque_coeff_a,omega_max_torque_a)


p=polyder(power_coeff_a);
temp=roots(p);
omega_max_power_a=temp(1)
max_power_a_hp=polyval(power_coeff_a,omega_max_power_a)/550


omega=linspace(800,6500)*rpm2rds;

figure(1)
plot(omega_data, torque_data,'*',omega,polyval(torque_coeff,omega))
grid
figure(2)
plot(omega_data,power_data/550,'*',omega,polyval(torque_coeff,omega).*omega/550)
grid

figure(3)
plot(omega_data,torque_data,'*',omega,polyval(torque_coeff_a,omega))
grid
figure(4)
plot(omega_data,power_data/550,'*',omega,polyval(power_coeff_a,omega)/550)
grid