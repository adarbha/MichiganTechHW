function xroot=brackroot(func,x1,x2,temp_d,thermo_property,z1,z2,z3,z4)

%   Bisection root finding function.  
%
%   The bisection method is used to determine the crank angle where the end
%   of combustion occurs for diesel and limited pressure cycles.  
%   Called by air_standard.m, real_air.m, complete_comb.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
%

%   This function will find the roots of an equation using the interval
%   halving bracketing method.  The function is defined in another function
%   func2.  The function asks for 2 values to be input, one for the left
%   bracket value, and one for the right.  The output is the values of x
%   for each iteration, the iteration number, and the error for each iteration.

%==========================================================================
xl = x1;
mit = 1000;
merr = 0.00001;
it = 0;
err = 1;

while err > merr & it < mit
   
   it = it + 1;
   xr = (xl + x2)/2;
   
   if xr ~=0
      err = abs((x2 - xl)/(x2+xl))*100;
   end
   
   test = feval(func,xl,temp_d,thermo_property,z1,z2,z3,z4)*feval(func,xr,temp_d,thermo_property,z1,z2,z3,z4);
   
   if test == 0
      error=0;
      
   elseif test < 0
      x2 = xr;
      
   else
      xl=xr;
   end
end
xroot = xr;