function [P,v,T,theta]=real_exp(Pinit,Tinit,vfinal,rc,step,R,vclearance,thetainit,thetafinal,M,temp_d,mix_h,mix_s)

%   This function calculates the isentropic expansion P-v curve for
%   constant composition mixtures.
%
%   This function iterates to find the isentropic pressure and specific
%   volumes along the expansion stroke for real gas mixtures.  The
%   entropy is dependent on pressure, temperature, and mixture composition.
%   Called by real_air.m, complete_comb.m
%
%   KMF     April 27/05 Rev 1
% 

theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
vinit=8.314/M*Tinit/Pinit;              %Calculate initial specific volume (m^3/kg)
vdisplacement = vfinal-vinit;        %Calculate displacement specific volume
if R == 0
v = vinit:(vfinal-vinit)/step:vfinal;   %Create specific volume vector
else
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
re=vfinal/vinit;
v=vclearance*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));
end


%Properties during expansion calculated with cubic spline interpolation

func = 'exp_func';
entro_o_state1 = spline(temp_d,mix_s,Tinit);
T(1)=Tinit;
for i = 2:length(v)
x1 = T(i-1);
x2 = T(i-1)*1.1;
T(i) = Secroot(func,x1,x2,temp_d,mix_s,vinit,v(i),entro_o_state1,Tinit);
end


P = 8.314/M*T./v;

