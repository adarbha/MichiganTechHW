function [P,v,T,theta]=air_stand_comp(Pinit,Tinit,rc,k,M,step,R,thetainit,thetafinal)

%   Air standard compression function for Engine_sim
%
%   Calculates the pressure-specific volume trace for an
%   air-standard isentropic compression. 
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%


%  This function calculates the pressure-specific volume trace for an
%  air-standard isentropic compression.  Temperature is also an optional 
%  output.
%           P (kPa)
%           T (°K)
%           M (kg/kmol)  - 28.96 kg/kmol for air
%  Input variables -        Pinit, initial pressure (kPa)
%                           Tinit, initial temperature (°K)   
%                           rc, compression ratio
%                           k, specific heat ratio
%                           M, molar mass (kg/kmol)
%                           step, how many points to calculate P and T at
%                           R, rod length to crank throw ratio (0 if not
%                           req)
%                           thetainit, initial crank angle (radians)
%                           thetafinal, final crank angle (radians)
%  Assumptions include: Constant specific heats, isentropic

theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
vinit=8.314/M*Tinit/Pinit;              %Calculate initial specific volume (m^3/kg)
vdisplacement = vinit*(rc-1)/rc;        %Calculate displacement specific volume
vfinal = vinit/(1+.5*(rc-1)*(R+1-cos(thetainit)-(R^2-(sin(thetainit)).^2).^.5));         %Calculate final compressed specific volume

%If only the P v trace is required, then the specific volume vector will
%only be a vector of constant space.  Otherwise, the specific volume will
%be calculated for the theta vector.  

if R == 0
v = vinit:(vfinal-vinit)/step:vfinal;   %Create specific volume vector
else
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;    % Create theta vector
v=vfinal*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));  %Create v vector based on theta
end
P = Pinit*vinit^k*v.^-k;                %Calculate pressure (kPa)
T = Tinit*vinit^(k-1)*v.^(1-k);         %Calculate temperature (°K)
