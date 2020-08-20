%%
% Class Example
% HW_9_Coast Down  J.E. Beard, Fall 2011
%

% Start clean
clear all;
close all;
clc;
rtd=180/pi;
dtr=pi/180;
mph_to_ft_sec=(88/60);
Ft_Sec_to_M_Sec=1/3.380840;
Lbf_to_N=4.448%
N_to_Lbf=1/Lbf_to_N;
rho_conversion=32.17*4.448/(9.81*0.3048^3);
Watts_to_Hp=1/746;
n=500; 

beta=1.4
V_init_Ft_Sec=60*mph_to_ft_sec;
V_init=V_init_Ft_Sec*0.3048




  
%% Add conversion factors here to put variables in SI units for use in Simulink model
% ...

Cd = 0.40;                              % Drag Coefficient (-)
%%
Weight_N=18680


g=9.81 % gravational acceleration in Meters/sec
mu_1=.01% Rolling resistance based on tire and road combination.


  
K_fv=44.704% for V in Meters/Sec
 
Area=2.4;% area in Meters^2

rho=1.24
Weight_max_mu_1=4200;

Mass=Weight_N/g;
%% Add the call to Simulink

open_system('Coast_Down_Model_AJ.mdl')
sim('Coast_Down_Model_AJ.mdl')

% you could also set or change paramemters in Simulink.
% set_param('name of model/Simulink bloc name', 'what is changing', 'value
% of the change') 


% Now get the parameters to use in the curve fit
figure(1)
n_time=length(Time_to_zero_AJ);
t_f=Time_to_zero_AJ(n_time);
V_initial=Velocity_out_AJ(1);

beta_White_Korst=V_init*sqrt(rho*Area*Cd/(2*Weight_N*mu_1));

plot(Time_to_zero_AJ,Velocity_out_AJ)
xlabel('Time in seconds during coast down')
ylabel('Velocity in M/sec during coast down')
title('Coast down for normal vehicle') 

%%Now for scaled plots
figure(2)
plot(Time_to_zero_AJ/t_f,Velocity_out_AJ/V_initial)
%%
tau=linspace(0,1,n_time);
V_White_Korst=V_initial*(1/beta)*(tan((1-tau)*atan(beta)));
V_White_Korst(1)
hold on
plot(tau,V_White_Korst/V_initial) 
xlabel('Ratio of time during coast down')
ylabel('Ratio of velocity during coast down')
title('Coast down for normal vehicle and the curve fit from White and Korst, beta is the variable of interest') 
Cd_White_Korst=2*Mass*atan(beta)/(rho*Area*V_initial*t_f)

Fr_White_Korst=V_initial*atan(beta)/(g*beta*t_f) 
%%now check the complete eqn. 

Q1=rho*Area*Cd*K_fv;
Q2=Weight_N*mu_1;
Q3=2*g*mu_1*(K_fv^2)*Mass*rho*Area*Cd-(Mass*mu_1*g)^2;
Time_exact=2*Mass*K_fv*(atan((Q1*V_initial+Q2)/sqrt(Q3))-atan((Q1*Velocity_out_AJ+Q2)/sqrt(Q3)))/sqrt(Q3);
figure(10)
 plot(Time_exact,Velocity_out_AJ)
hold on
plot(Time_to_zero_AJ,Velocity_out_AJ)
xlabel('Time in seconds during coast down')
ylabel('Velocity in ft/sec during coast down')
title('Coast down for normal vehicle, versus the integrated solution') 

Coast_Down_Data=[Time_to_zero_AJ,Velocity_out_AJ];
xlswrite('Coast_AJ',Coast_Down_Data);