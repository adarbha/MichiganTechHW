function [f] = fun1(t,z)

%Constants
rho = 0.00236; %lb-sec^2/ft^4
A = 2*(3.3^2); %ft^2
Cd = 0.35;
mu = 0.8;
M = 4074; %lb
W = 4074*32; 

f = zeros(2,1);
x = z(1);
v = z(2);

D = 0.5*(rho*Cd*A*(v.^2));

dvdt = -(mu*W + D)/M;

f(2) = dvdt;
f(1) = v;

end


