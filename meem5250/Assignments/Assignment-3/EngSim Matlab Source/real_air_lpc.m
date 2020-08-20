function y = real_air_lpc(T,temp_d,mix_h,qin_cp,enthalpy_2a,z3,z4)

%   Equation for calculating the end of combustion temperature for an
%   real air limited pressure cycle.
%
%   This function calculates the temperature at the end of limited P
%   real air heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, constant P energy input,
%   enthalpy at state 2a)
%   Called by real_air_comb.m
%
%   KMF     April 27/05 Rev 1
%   
y = spline(temp_d,mix_h,T) - enthalpy_2a -qin_cp;