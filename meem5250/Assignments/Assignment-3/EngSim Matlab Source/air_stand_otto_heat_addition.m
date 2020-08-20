function [Pfinal,vfinal,Tfinal] = air_stand_otto_heat_addition(Tinit,v,qin,Cv,M)

%  This function calculates the maximum temperature and pressure for an Air
%  Standard Otto Cycle engine.  
%  Required inputs are - initial temp (°K)
%                        specific volume (m^3/kg)
%                        specific heat input (kJ/kg)
%                        constant volume specific heat (kJ/kg°K)
%                        molar mass (kg/kmol)


Tfinal = Tinit + qin/Cv;
Pfinal = 8.314/M*Tfinal/v;
Pinit = 8.314/M*Tinit/v;
Tfinal = [Tinit Tfinal];
vfinal = [v v];
Pfinal = [Pinit Pfinal];


