function y = real_air_ottoc(T,temp_d,mix_h,qin,M,int_energy_2,z4)

%   Equation for calculating the end of combustion temperature for an
%   real air otto cycle.
%
%   This function calculates the temperature at the end of otto
%   real air heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, energy input, molar mass,
%   initial internal energy)
%   Called by real_air_comb.m
%
%   KMF     April 27/05 Rev 1
%   

y = spline(temp_d,mix_h,T) - 8.314*T - int_energy_2 -qin*M;