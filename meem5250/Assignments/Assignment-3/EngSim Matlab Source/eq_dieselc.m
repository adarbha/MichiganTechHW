function y = eq_dieselc(T,temp_d,prod_h,enthalpy_2)

%   Equation for calculating the end of combustion temperature for an
%   equilibrium diesel cycle.
%
%   This function calculates the temperature at the end of diesel
%   equilibrium combustion (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, initial enthalpy)
%   Called by diesel_solver.m
%
%   KMF     April 27/05 Rev 1
%    



y = spline(temp_d,prod_h,T) - enthalpy_2;