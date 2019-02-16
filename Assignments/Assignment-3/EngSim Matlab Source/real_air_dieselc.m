function y = real_air_dieselc(T,temp_d,mix_h,qin,M,enthalpy_2,z4)

%   Equation for calculating the end of combustion temperature for an
%   real air diesel cycle.
%
%   This function calculates the temperature at the end of diesel
%   real air heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, energy input, molar mass,
%   enthalpy at state 2)
%   Called by real_air_comb.m
%
%   KMF     April 27/05 Rev 1

y = spline(temp_d,mix_h,T) - enthalpy_2 -qin*M;