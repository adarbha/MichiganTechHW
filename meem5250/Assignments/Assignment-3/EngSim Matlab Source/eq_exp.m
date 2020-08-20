function [P,v,T,theta,X,M_resid,prod_h]=eq_exp(Pinit,Tinit,vfinal,rc,step,R,vclearance,thetainit,...
                        thetafinal,M1,temp_d,mix_s,phi,species_data,prod_data,prod_thdata,P_EVO,T_EVO)
                    
%   This function calculates the isentropic expansion P-v curve for
%   equilibrium mixtures.
%
%   This function iterates to find the isentropic pressure and specific
%   volumes along the expansion stroke for equilibrium mixtures.  The
%   entropy is dependent on pressure, temperature, and mixture composition.
%   The entropy vector prod_s has to take the changing composition into
%   consideration.  
%   Called by eq_comb.m
%
%   KMF     April 27/05 Rev 1
%                            
                        
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
vinit=8.314/M1*Tinit/Pinit;              %Calculate initial specific volume (m^3/kg)
vdisplacement = vfinal-vinit;        %Calculate displacement specific volume
if R == 0
v = vinit:(vfinal-vinit)/step:vfinal;   %Create specific volume vector
else
theta = thetainit:(thetafinal-thetainit)/step:thetafinal;
re=vfinal/vinit;
v=vclearance*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));
end
entro_o_state1 = spline(temp_d,mix_s,Tinit);
T(1)=Tinit;
P(1)=Pinit;
[X_endcomb,P_endcomb,M_endcomb] = eq_solver(species_data,prod_data,phi,Tinit,Pinit,vinit);
X(:,1) = X_endcomb;
%Properties during expansion calculated with cubic spline interpolation
for i = 2:length(v)
if step ~= 1 
x1 = T(i-1);
x2 = T(i-1)*.99;
y1 = P(i-1);
else
    x1 = T_EVO;
    x2 = T_EVO*.99;
    y1 = P_EVO;
end



merr = .01;
Terr = 1;
Perr = 1;
mit = 1000;
it = 0;
    while Terr > merr & Perr > merr & it < mit
   
   it = it + 1;
    

    [X1,Press,M_resid] = eq_solver(species_data,prod_data,phi,x1,y1,v(i));

    prod_data(:,1) = X1;
        prod_h=zeros(length(prod_thdata),1); 
        prod_s=zeros(length(prod_thdata),1); 
        k = 2;
        for l = 1:length(prod_data(:,1))
            prod_h = prod_data(l,1)*(prod_data(l,3)+prod_thdata(:,k+1)) + prod_h;    
            prod_s = prod_data(l,1)*(prod_thdata(:,k)-8.314*log(prod_data(l,1)))...
                + prod_s;
            k = k + 3;
        end
    P1 = 8.314/M_resid*x2/v(i);
    f1 = eq_exp_func(x1,temp_d,prod_s,vinit,v(i),entro_o_state1,Pinit,P1,M1,M_resid);
    f2 = eq_exp_func(x2,temp_d,prod_s,vinit,v(i),entro_o_state1,Pinit,P1,M1,M_resid);
    x3 = x2 - f2*(x2-x1) / (f2 - f1);
    Terr = abs((x3 - x2)/x3) * 100;
   
    x1 = x2;
    x2 = x3;
    Perr = abs((P1-y1)/P1);
    y1 = P1;

    end
    T(i) = x3;
    P(i) = 8.314/M_resid*x3/v(i);
    X(:,i) = X1;
end