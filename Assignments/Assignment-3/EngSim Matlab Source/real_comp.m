function [P,v,T,theta]=real_comp(Pinit,Tinit,rc,step,R,thetainit,thetafinal,M,temp_d,mix_h,mix_s)

%   This function calculates the isentropic compression P-v curve for
%   fixed composition mixtures.
%
%   This function iterates to find the isentropic pressure and specific
%   volumes along the compression stroke for real gas mixtures.  The
%   entropy is dependent on pressure, temperature, and mixture composition.
%   Called by real_air.m, complete_comb.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
% 

vinit=8.314/M*Tinit/Pinit;             %Calculate initial specific volume (m^3/kg)
vdisplacement = vinit*(rc-1)/rc;        %Calculate displacement specific volume
vfinal = vinit - vdisplacement;         %Calculate final compressed specific volume  

if R == 0
v = vinit:(vfinal-vinit)/step:vfinal;   %Create specific volume vector
else
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;    % Create theta vector
vfinal = vinit/(1+.5*(rc-1)*(R+1-cos(thetainit)-(R^2-(sin(thetainit)).^2).^.5));
v=vfinal*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));  %Create v vector based on theta
end

%Properties during compression calculated with cubic spline interpolation

s_init = spline(temp_d,mix_s,Tinit);
T(1)=Tinit;
func = 'comp_func';
for i = 2:length(v)
    
x1 = T(i-1);
x2 = T(i-1)*1.1;

T(i) = Secroot(func,x1,x2,temp_d,mix_s,vinit,v(i),s_init,Tinit);

end

P = 8.314/M*T./v;
