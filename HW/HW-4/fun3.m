function [f] = fun3(t,z)


%Constants
rho = 0.00236; %lb-sec^2/ft^4
A = 2*(3.3^2); %ft^2
Cd = 0.35;
mu = 0.8;
g = 32.2;
M = 4074; %lb
W = 4074*g; 
L = 108.5/12; %feet
a = 0.45*L;
b = 0.55*L;
h = 20.5/12; %feet
R = 12.11/12; %feet
If = 12/12; %feet-lb/sec^3
Ir = 13.5/12; %feet-lb-sec^3
f0 = 0.013;
f1 = 6.5e-7;

f = zeros(3,1);
x = z(1);
v = z(2);
E = z(3);

fr = f0 + f1*((v*(60/88)/100)^2.5);
D = 0.5*(rho*Cd*A*(v.^2));

AA = zeros(5);
RHS = [0; (W*b); W; 0; 0];

AA(1,:) = [M mu mu 0 0];
AA(2,:) = [M*h 0 L 0 0];
AA(3,:) = [0 1 1 0 0];
AA(4,:) = [If/R 0 -(mu*R) 0 1];
AA(5,:) = [Ir/R -(mu*R) 0 1 0];

res = AA\RHS;

Tbf = res(5);
Tbr = res(4);
dvdt = res(1);
dEdt = (Tbf + Tbr)*v/R;

f(3) = dEdt;
f(2) = dvdt;
f(1) = v;




end


