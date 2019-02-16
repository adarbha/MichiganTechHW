function [x3,X1,M_resid,prod_h] = diesel_solver(x1,x2,v,P,phi,temp_d,species_data,prod_data,prod_thdata,enthalpy_2)

%   Solves heat addition process for equilibrium diesel cycle.
%
%   Calculates temperature and end of combustion composition, molar mass,
%   and enthalpy.  Uses a modified secant method program which recalculates
%   equilibrium composition and therefore enthalpy every iteration, based
%   on the iteration temperature.  
%   Called by real_eq_comb.m
%
%   KMF     April 27/05 Rev 1
%    

merr = .01;
err = 1;
mit = 1000;
it = 0;
while err > merr & it < mit
   
   it = it + 1;
           
   k = 2;
   [X1,P1,M_resid]=eq_solver(species_data,prod_data,phi,x2,P,v);
   prod_data(:,1) = X1;
   prod_h=zeros(length(prod_thdata),1); 
   prod_s=zeros(length(prod_thdata),1); 
   for i = 1:length(prod_data(:,1))
       prod_h = prod_data(i,1)*(prod_data(i,3)+prod_thdata(:,k+1)) + prod_h;    
       prod_s = prod_data(i,1)*prod_thdata(:,k) + prod_s;
       k = k + 3;
   end
   f1 = feval('eq_dieselc',x1,temp_d,prod_h,enthalpy_2);

   f2 = feval('eq_dieselc',x2,temp_d,prod_h,enthalpy_2);
     
   x3 = x2 - f2*(x2-x1) / (f2 - f1);
   err = abs((x3 - x2)/x3) * 100;
   
   x1 = x2;
   x2 = x3;
   P = P1;
end
