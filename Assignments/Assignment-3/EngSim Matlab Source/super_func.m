function y = comp_func(T,temp_d,mix_s,Pinit,P,s_init,Tinit)

%   Supercharger compression entropy function 
%
%   This function calculates the temperature during compression of a real
%   mixture during the compressor process during Supercharging/Turbocharging.
%   Assumes constant mol fractions of species.  
%   Called by real_super_comp.m
%
%   KMF     April 27/05 Rev 1

y = s_init + 8.314*log(P/Pinit)-spline(temp_d,mix_s,T);