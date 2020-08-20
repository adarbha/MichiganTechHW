function [P,v,T]=real_bd(Pinit,Tinit,Pfinal,step,M,temp_d,mix_h,mix_s)

%   This function calculates the blowdown process for real gas mixtures.
%   Composition is assumed to be constant.  The isentropic relation s1 = s2
%   is solved using the secant method.
%   Called by real_air.m, complete_comb.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
%

vinit=8.314/M*Tinit/Pinit;             %Calculate initial specific volume (m^3/kg)
P = Pinit:(Pfinal-Pinit)/step:Pfinal;

%Properties during expansion calculated with cubic spline interpolation
func = 'bd_func';
entro_o_state1 = spline(temp_d,mix_s,Tinit);
T(1)=Tinit;
for i = 2:length(P)
x1 = T(i-1);
x2 = T(i-1)*1.1;
T(i) = Secroot(func,x1,x2,temp_d,mix_s,Pinit,P(i),entro_o_state1,Tinit);
end


v = 8.314/M*T./P;

