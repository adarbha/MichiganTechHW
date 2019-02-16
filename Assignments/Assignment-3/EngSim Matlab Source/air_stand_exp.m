function [P,v,T,theta]=air_stand_exp(Pinit,Tinit,vfinal,k,M,step,rc,R,vclearance,thetainit,thetafinal)

%   Air standard expansion function for Engine_sim
%
%   Calculates the pressure-specific volume trace for an
%   air-standard isentropic expansion.
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%

%  This function calculates the pressure-specific volume trace for an
%  air-standard isentropic expansion.  Temperature is also an optional 
%  output.
%           P (kPa)
%           T (°K)
%           M (kg/kmol)  - 28.96 kg/kmol for air
%  Input variables -        Pinit, initial pressure (kPa)
%                           Tinit, initial temperature (°K)   
%                           vfinal, final specific volume
%                           k, specific heat ratio
%                           M, molar mass (kg/kmol)
%                           step, how many points to calculate P and T at
%                           R, rod length to crank throw ratio (0 if not req)
%                           vclearance, clearance specific volume to
%                           calculate specific volume based on crank angle (m^3/kg)
%                           thetainit, initial crank angle (radians)
%                           thetafinal, final crank angle (radians)
%  Assumptions include: Constant specific heats, isentropic

theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
vinit=8.314/M*Tinit/Pinit;              %Calculate initial specific volume (m^3/kg)
vdisplacement = vfinal-vinit;        %Calculate displacement specific volume
if R == 0
v = vinit:(vfinal-vinit)/step:vfinal;   %Create specific volume vector
else
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
re=vfinal/vinit;
v=vclearance*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));
end
P = Pinit*vinit^k*v.^-k;                %Calculate pressure (kPa)
T = Tinit*vinit^(k-1)*v.^(1-k);         %Calculate temperature (°K)
