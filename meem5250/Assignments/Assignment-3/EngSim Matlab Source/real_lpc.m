function y = real_lpc(T,temp_d,mix_h,prod_t,prod_h,enthalpy_2a,z4)
%
%   Equation for calculating the end of combustion temperature for 
%   a complete combustion product fuel air limited pressure cycle.
%
%   This function calculates the entropy at the end of limited pressure
%   complete combustion heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, products temp vector, products
%   enthalpy vector, enthalpy at state 2a)
%   Called by real_complete_comb.m
%
%   KMF     April 27/05 Rev 1

y = spline(prod_t,prod_h,T) - enthalpy_2a;