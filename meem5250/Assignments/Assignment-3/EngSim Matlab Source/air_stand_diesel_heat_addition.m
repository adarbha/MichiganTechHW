function [vfinal,Tfinal] = air_stand_diesel_heat_addition(Tinit,P,qin,Cp,M)

%   Air standard diesel heat addition function for Engine_sim
%
%   Calculates final temp and pressure for air standard diesel cycle.  
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%


%  This function calculates the final temperature and pressure for an Air
%  Standard Diesel Cycle engine.  
%  Required inputs are - initial temp (°K)
%                        specific volume (m^3/kg)
%                        specific heat input (kJ/kg)
%                        constant pressure specific heat (kJ/kg°K)
%                        molar mass (kg/kmol)

v = 8.314/M*Tinit/P;
Tfinal = Tinit + qin/Cp;
vfinal = 8.314/M*Tfinal/P;
vfinal = [v vfinal];
Tfinal = [Tinit Tfinal];
Pfinal = [P P];


