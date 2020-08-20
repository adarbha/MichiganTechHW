clear all;
clc;

%Vehicle data given
weight_lbf = 3776;
weight_N = 3776*4.45;
density_sae = 0.00236;
g_ft_sq_sec = 32.17;
g_m_sq_sec = g_ft_sq_sec*0.33;
Cd = 0.4;
area_sq_m = 2.7;
wheel_radius_m = 0.34;
wheel_base_m = 2.86;
hcg_m = 0.5;
mass_kg = weight_lbf*4.45/g_m_sq_sec;
mu = 0.8; %assumption
f_r = 0.01; %assumption
l_a_m = 1.37;
l_b_m = 1.49;
differential_ratio = 3.08;
n_transmission = 0.97;
max_power_hp = 85;
max_power_W = max_power_hp*746;

%Running the curve fit for the data given
N = 500:500:4000;
T_lbf = [134 144 150 153 151 145 132 115];
p = polyfit(N,T_lbf,2);


%fitted data stored
new_N = linspace(500,4000,1e6);
f = polyval(p,new_N);
T_Nm = f*1.36;

figure(1)
plot(new_N,T_Nm)
xlabel('RPM');
ylabel('Torque in Nm');

%Calculating acceleration from given torque and wheel radius
F = (4.45/wheel_radius_m)*f;
acceleration_m_sq_sec = F/mass_kg;
%Calculating maximum tractive force
A = mu*weight_N*(l_a_m - f_r*(hcg_m-wheel_radius_m))/wheel_base_m;
B = 1 - (mu*hcg_m/wheel_base_m);
Ft_max_N = A/B;

%Calculating speed and distance of the vehicle by integrating the performance
%equation using the euler method(for power = 85 hp)
[vel_m_s disp_m] = euler1_adarbha(Ft_max_N,mass_kg,63410,weight_N,1000);
vel_kmph = vel_m_s*(18/5);

%plotting velocity with time
time_s = 1:100000;

% figure(2)
% plot(time_s, vel_kmph)
% xlabel('time in sec');
% ylabel('velocity in kmph');

% figure(3)
% plot(time_s, disp_m)
% xlabel('time in sec');
% ylabel('displacement in m');


%Max velocity in this velocities acquired by integration should give me
%max possible velocity

max_vel_m_s = max(vel_m_s);
max_vel_kmph = max_vel_m_s*(18/5);
max_vel_mph = max_vel_kmph/1.6;

%Plotting the values of tractive force v/s velocity for a CVT at WOT

Ft_cvt_N(100000) = Ft_max_N;
for q = 2:100000
    if(max_power_W/vel_m_s(q) > Ft_max_N)
        Ft_cvt_N(q) = Ft_max_N;
    else
        Ft_cvt_N(q) = max_power_W/vel_m_s(q);
    end
end

% figure(4)
% hold on
% plot(vel_kmph, Ft_cvt_N)
% xlabel('Velocity in kmph');
% ylabel('Tractive force(CVT) in N');
% plot(vel_m_s, Ft_max_N, 'r-')
% hold off


%Finite ratio transmission - I used a gear reduction of 4 for the first, 3
%for the second and 1 for the third gear

rpm_wheel = (vel_m_s*60)/(wheel_radius_m*2*pi);

%Now the rpm of the wheel should be taken back to the engine so that it can
%be mapped with its torque from the polyfit equation

gear_ratio = [4 3 1];

rpm_gear_1 = rpm_wheel*differential_ratio*n_transmission*gear_ratio(1);
rpm_gear_2 = rpm_wheel*differential_ratio*n_transmission*gear_ratio(2);
rpm_gear_3 = rpm_wheel*differential_ratio*n_transmission*gear_ratio(3);

Ft_manual_N(100000) = 0;

for h = 1:100000
    if(polyval(p,rpm_gear_1(h)) > polyval(p,rpm_gear_2(h)))
        Ft_manual_N(h) = polyval(p,rpm_gear_1(h))*differential_ratio*n_transmission*gear_ratio(1)*1.36/wheel_radius_m;
    else if(polyval(p,rpm_gear_2(h)) > polyval(p,rpm_gear_3(h)))
            Ft_manual_N(h) = polyval(p,rpm_gear_2(h))*differential_ratio*n_transmission*gear_ratio(2)*1.36/wheel_radius_m;
        else
            Ft_manual_N(h) = polyval(p,rpm_gear_3(h))*differential_ratio*n_transmission*gear_ratio(3)*1.36/wheel_radius_m;   
        end
    end
end
            
%plotting ft manual versus velocity red line is the maximum tractive force

% figure(5)
% hold on
% plot(vel_kmph(1:1500),Ft_manual_N(1:1500))
% xlabel('Velocity in kmph');
% ylabel('Tractive force(manual) in N');
% plot(vel_m_s(1:1500),Ft_max_N,'r-')
% hold off









