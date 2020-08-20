function [X,P,M_resid] = eq_solver(species_data,prod_data,phi,x1,P,v)

%   This function is used to determine equilibrium compositions by calling
%   eq_composition.  This function is required to calculate the pressure of
%   the mixture if a specific volume is given.  
%   Called by otto_solver.m, diesel_solver.m, lp_solver.m, eq_exp.m
%
%   KMF     April 27/05 Rev 1
%


merr = .001;
err = 1;
mit = 100;
it = 0;
PSATM = 101.325;
X = eq_composition(species_data,phi,x1,P,PSATM);
while err > merr & it < mit
    prod_data(:,1)=X(1:11);
    M_resid = sum(prod_data(:,1).*prod_data(:,2))/sum(prod_data(:,1));
   if v ~=0
       P = 8.314/M_resid*x1/v;
   end
   X1 = eq_composition(species_data,phi,x1,P,PSATM);
   error = X1(1:11)-X(1:11);
   err = norm(error);
   X = X1;
end
X = X(1:11);