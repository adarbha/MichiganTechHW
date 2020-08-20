%As directed the initial part of the code has been copied from HW1

%Used set_param function at the command proompt so that these variables are
%declared each time the model is run

clear all;
clc;


%------------------------------PART-I-----------------------------------
%1a.Declaring arrays for time, velocity and slope

time_s = [0,13,145,148,160,165.5,180,183,300,350,390,493.6,500];
time_s_slope = [0,13,145,148,160,165.5,180,183,299,300,349,350,389,390,493.6,500];
vel_mph = [0,60,60,40,40,70,70,55,55,55,55,55,0];
slope_deg = [0,0,0,0,0,0,0,0,0,4,4,-4,-4,0,0,0];
T1 = length(time_s);
time_end = time_s(T1);

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
mass = weight_N/g;

