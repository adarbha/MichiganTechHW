function [vfinal,Tfinal,Tcv] = air_stand_lp_heat_addition(Tinit,vinit,P,qin,Cp,Cv,M)

%   Air standard limited pressure heat addition function for Engine_sim
%
%   Calculates the temperature and pressure for state 2a and 3 for a limited
%   pressure air standard cycle.
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%


Tcv = P*vinit/(8.314/M);
qincv = Cv*(Tcv-Tinit);
qincp = qin - qincv;

Tfinal = Tcv + qincp/Cp;
vfinal = 8.314/M*Tfinal/P;



