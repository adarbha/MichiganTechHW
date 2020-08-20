function y = eq_exp_func(T,temp_d,mix_s,vinit,v,entro_o_state1,Pinit,P,M1,M2)


%   This function calculates the temperature during expansion of a real
%   mixture in equilibrium.  
%
%   This function is used by eq_exp.m to calculate the entropy of the
%   equilibrium mixture.
%   Called by eq_exp.m
%
%   KMF     April 27/05 Rev 1
%                         


ent_1 = (entro_o_state1 - 8.314*log(Pinit/101.325))/M1;
 

ent_2 = (spline(temp_d,mix_s,T) - 8.314*log(P/101.325))/M2;
y = ent_1 - ent_2;
a = spline(temp_d,mix_s,T);