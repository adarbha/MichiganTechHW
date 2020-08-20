function [x3] = Secroot(func,x1,x2,temp_d,thermo_property,z1,z2,z3,z4)

%	This function will find the roots of an equation using the secant method. 
%  The equation is defined in another function func.  The function asks 
%  for 2 initial guess values to be input.  The value for the root is
%  output.  the function includes a temperature vector input, thermodynamic
%  property input, and 4 miscellaneous inputs as required by the function.
%  Called by real_super_comp.m, real_comp.m, real_air_comb.m, real_exp.m,
%  real_bd.m
%
%   KMF     April 27/05 Rev 1
% 



%==========================================================================

merr = .001;
err = 1;
mit = 100;
it = 0;

while err > merr & it < mit
   
   it = it + 1;
   f1 = feval(func,x1,temp_d,thermo_property,z1,z2,z3,z4);
   f2 = feval(func,x2,temp_d,thermo_property,z1,z2,z3,z4);
   
   x3 = x2 - f2*(x2-x1) / (f2 - f1);
   err = abs((x3 - x2)/x3) * 100;
   
   x1 = x2;
   x2 = x3;
end
