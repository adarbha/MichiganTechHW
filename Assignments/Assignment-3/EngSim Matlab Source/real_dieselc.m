function y = real_dieselc(T,temp_d,mix_h,prod_t,prod_h,enthalpy_2,z4)

%   Equation for calculating the end of combustion temperature for 
%   a complete combustion product fuel air diesel cycle.
%
%   This function calculates the entropy at the end of diesel
%   complete combustion heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, products temp vector, products
%   enthalpy vector, enthalpy at state 2)
%   Called by real_complete_comb.m
%
%   KMF     April 27/05 Rev 1

y = spline(prod_t,prod_h,T) - enthalpy_2;