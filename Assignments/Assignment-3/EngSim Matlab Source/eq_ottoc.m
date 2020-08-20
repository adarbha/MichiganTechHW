function y = eq_ottoc(T,temp_d,prod_h,int_energy_2)

%   Equation for calculating the end of combustion temperature for an
%   equilibrium otto cycle.
%
%   This function calculates the temperature at the end of otto
%   equilibrium combustion (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, initial internal energy)
%   Called by otto_solver.m
%
%   KMF     April 27/05 Rev 1
%    

y = spline(temp_d,prod_h,T) - 8.314*T - int_energy_2;