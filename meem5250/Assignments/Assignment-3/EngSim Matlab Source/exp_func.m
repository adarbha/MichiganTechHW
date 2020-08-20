function y = exp_func(T,temp_d,mix_s,vinit,v,entro_o_state1,Tinit)
% This function calculates the temperature during expansion of a real
% mixture

y = entro_o_state1 + 8.314*log(vinit/v*(T)/Tinit)-spline(temp_d,mix_s,T);