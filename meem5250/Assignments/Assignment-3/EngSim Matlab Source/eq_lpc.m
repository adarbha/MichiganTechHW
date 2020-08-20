function y = eq_lpc(T,temp_d,prod_h,enthalpy_2a)

%   Equation for calculating the end of combustion temperature for an
%   equilibrium limited pressure cycle.
%
%   This function calculates the temperature at the end of limited pressure
%   equilibrium combustion (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, initial enthalpy)
%   Called by lp_solver.m
%
%   KMF     April 27/05 Rev 1
%    


y = spline(temp_d,prod_h,T) - enthalpy_2a;