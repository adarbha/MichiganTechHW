function [d]=dPdt(t,P)

%   Differential equations for air standard arbitrary heat release cycle.
%
%   These equations are solved by matlab's built in ODE45 solver.  
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
%    

global k vinit rc R qin ts tb
%cylinder volume (m^3/kg)
v = vinit/rc * (1+(rc-1)/2*(R+1-cos(t)-sqrt(R^2-(sin(t))^2)));   

%dV/dtheta (m^3/kg/radian) 
dVdt=vinit/rc*((rc-1)/2*sin(t)*(1+cos(t)/sqrt(R^2-(sin(t))^2)));    

if t<ts | t>ts+tb                   
   dfdt=0;                           
else
   dfdt=0.5*pi/tb*sin(pi*(t-ts)/tb);     
   
end
d=-k*P/v*dVdt+(k-1)*qin/v*dfdt;      
