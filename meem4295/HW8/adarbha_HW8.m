% Purge and clean
 clc
 clear all;
 close all;
 
 % Vehicle Data
 
 Weight_N = 18680;
 Mass_kg = Weight_N/9.8;
 Area_sq_m = 2.4;
 rho = 1.24; %density in kg/m^3
 wheel_radius = 0.318; %meters
 wheel_base = 2.89; %meters
 
 %Velocity data from xls file
 
 Time=xlsread('Coast_AJ.xls','A:A');
 Velocity_mps=xlsread('Coast_AJ.xls','B:B');
 
 
%  figure(1)
%  plot(Time, Velocity_mps)
%  xlabel('Time in s')
%  ylabel('Velocity in m/s')
%  title('Coast down data')
 
 
 %Extrapolation for data for obtaining T-final
 p = polyfit(Velocity_mps, Time, 3); % Third degree polyfit
 T_final = polyval(p, 0);
 Time = transpose(Time);
 Time = [Time T_final];
 
 %Calculating the values of tau and (v)/(vi) - This curve is obtained from
 %experimental data and the curves obtained from mathematical data should
 %fit to this data
 
 Velocity_mps = transpose(Velocity_mps);
 Velocity_mps = [Velocity_mps 0];
 vel_ratio_actual =  Velocity_mps/(Velocity_mps(1));
 Tau_actual = Time/(T_final);
 
%  figure(2)
%  plot(Tau_actual, vel_ratio_actual)
%  xlabel('Tau')
%  ylabel('V/V_initial')
%  title('Actual curve')
 
 %Simulating the function(Tau, Beta as independent variables and velocity ratio as a dependent variable)
 
 % I plan to adopt the classical least square method to check the
 % difference between simulated data and and to freeze the simulation when
 % it hits a convergence point - in this case a preset value of difference
 % of 0.01
 
 Tau_sim = Tau_actual; % The interval of tau values is small enough - considering it for simulating the data
 beta = 0:0.01:10;
 beta = beta(beta~=0); % The function goes to infinity at zero - necessiating truncation
 rms_error = 1; %initialization
 j = 1; %initialization
 
 
 while(rms_error > 0.01)
 beta(j);
     for i = 1:length(Tau_sim)
        vel_ratio_sim(i) = (1/beta(j))*tan((1-Tau_sim(i))*atan(beta(j)));
     end
     
  rms_error = sqrt(mean((vel_ratio_sim-vel_ratio_actual).^2));
 
  j = j+1; 
 
 
 end
 
 Vel_sim = vel_ratio_sim*Velocity_mps(1);
 
 % Plots
 hold on
 plot(Tau_sim, vel_ratio_sim, 'g')
 plot(Tau_actual, vel_ratio_actual, 'r')
 xlabel('Tau')
 ylabel('V/V_initial')
 hold off
 
 %Calculating drag coefficient and rolling resistance coefficient
 Cd = (2*Mass_kg*beta(j)*atan(beta(j))/(rho*Area_sq_m*Velocity_mps(1)*T_final)); %Drag coefficient
 fr = (rho*Cd*Area_sq_m*(Velocity_mps(1)^2))/(2*Weight_N*(beta(j)^2)); %Rolling resistance coefficient
 
 
 %Running a simulink model to obtain values for acceleration and ditsnce
 %travelled
 
  %open_system('adarbha_HW8_sim.mdl')
  sim('adarbha_HW8_sim.mdl')
  %Actual values
  
  %Distances
  dist_actual = max(distance_actual.signals.values);
  dist_sim = max(distance_sim.signals.values);
  
  %Accelerations
  accel_actual = acceleration_actual.signals.values;
  accel_sim =  acceleration_sim.signals.values;
  
  
 
 
 