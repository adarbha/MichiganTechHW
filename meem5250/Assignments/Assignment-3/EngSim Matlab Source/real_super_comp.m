function [P,v,T,w_super]=real_super_comp(Pinit,Tinit,Pfinal,step,M,comp_eff,temp_d,mix_h,mix_s)

%   This function calculates the isentropic compression P-v curve for
%   fixed composition mixtures during supercharging.
%
%   This function iterates to find the isentropic pressure and specific
%   volumes during supercharging/compressor stage of turbocharging
%   for real gas mixtures.  The entropy is dependent on pressure, 
%   temperature, and mixture composition.
%   Called by real_air.m, complete_comb.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
% 

vinit=8.314/M*Tinit/Pinit;             %Calculate initial specific volume (m^3/kg)

P = Pinit:(Pfinal-Pinit)/step:Pfinal;   %Create pressure vector


%Properties during compression calculated with cubic spline interpolation

s_init = spline(temp_d,mix_s,Tinit);
T(1)=Tinit;
func = 'super_func';
for i = 2:length(P)
    
x1 = T(i-1);
x2 = T(i-1)*1.1;

T(i) = Secroot(func,x1,x2,temp_d,mix_s,Pinit,P(i),s_init,Tinit);

end

%Calculate supercharger work (including isentropic efficiency)
w_super = (spline(temp_d,mix_h,T)-spline(temp_d,mix_h,Tinit))/comp_eff/M;
h_super = (spline(temp_d,mix_h,Tinit))/M + (w_super);

%Get new temperature vector accounting for isentropic efficiency

T = spline(mix_h,temp_d,h_super*M);

v = 8.314/M*T./P;




