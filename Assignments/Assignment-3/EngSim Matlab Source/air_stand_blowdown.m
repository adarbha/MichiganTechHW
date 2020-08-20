function [P,v,T]=air_stand_blowdown(Pinit,Tinit,Pfinal,k,M,step)

%   Air standard blowdown function for Engine_sim
%
%   Calculates the pressure-specific volume trace for an
%   air-standard isentropic blowdown. 
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%

%  This function calculates the pressure-specific volume trace for an
%  air-standard isentropic blowdown.  Temperature is also an optional 
%  output.
%           P (kPa)
%           T (°K)
%           M (kg/kmol)  - 28.96 kg/kmol for air
%  Input variables -        Pinit, initial pressure (kPa)
%                           vinit, initial specific volume   
%                           Pfinal, final pressure (kPa)
%                           k, specific heat ratio
%                           M, molar mass (kg/kmol)
%                           step, how many points to calculate P and T at
%                           vclearance, clearance specific volume to
%                           calculate specific volume based on crank angle (m^3/kg)

%  Assumptions include: Constant specific heats, isentropic
vinit=8.314/M*Tinit/Pinit;             %Calculate initial specific volume (m^3/kg)
P = Pinit:(Pfinal-Pinit)/step:Pfinal;   %Create specific volume vector
v = vinit*Pinit^(1/k)*P.^-(1/k);                %Calculate pressure (kPa)
T = Tinit*vinit^(k-1)*v.^(1-k);         %Calculate temperature (°K)
