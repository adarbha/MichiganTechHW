function y = real_ottoc(T,temp_d,mix_h,prod_t,prod_h,int_energy_2,z4)

%   Equation for calculating the end of combustion temperature for 
%   a complete combustion product fuel air otto cycle.
%
%   This function calculates the entropy at the end of otto
%   complete combustion heat release (specified temperature, temp vector for 
%   interpolating, mixture enthalpy vector, products temp vector, products
%   enthalpy vector, internal energy at state 2)
%   Called by real_complete_comb.m
%
%   KMF     April 27/05 Rev 1
%

y = spline(temp_d,prod_h,T) - 8.314*T - int_energy_2;