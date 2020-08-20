function y = bd_func(T,temp_d,mix_s,Pinit,P,entro_o_state1,Tinit)

%   Blowdown entropy function 
%
%   This function calculates the temperature during expansion of a real
%   mixture during the blowdown process.  Assumes constant mol fractions
%   of species.  
%   Called by real_bd.m
%
%   KMF     April 27/05 Rev 1
%




y = entro_o_state1 + 8.314*log(P/Pinit)-spline(temp_d,mix_s,T);