function y = comp_func(T,temp_d,mix_s,vinit,v,s_init,Tinit)

%   Compression entropy function 
%
%   This function calculates the temperature during compression of a real
%   mixture during the compression process.  Assumes constant mol fractions
%   of species.  
%   Called by real_comp.m
%
%   KMF     April 27/05 Rev 1
%

y = s_init + 8.314*log(vinit/v*(T)/Tinit)-spline(temp_d,mix_s,T);