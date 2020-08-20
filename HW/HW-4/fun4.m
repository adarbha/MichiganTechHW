function[f] = fun4(t,z)


x = z(1);
v = z(2);

f = zeros(2,1);

%Constants
rho = 0.00236; %lb-sec^2/ft^4
A = 2*(3.3^2); %ft^2
Cd = 0.35;
g = 32.2;
%M = 4074; %lb
W = 4074; 
L = 108.5/12; %feet
a = 0.45*L;
b = 0.55*L;
h = 20.5/12; %feet
R = 12.11/12; %feet
If = 12/12; %feet-lb/sec^3
Ir = 13.5/12; %feet-lb-sec^3
f0 = 0.013;
f1 = 6.5e-7;
Pa = 200; %line pressure
Pf = Pa
if Pa <= 290
    Pr = Pa;
else
    Pr = 290 + 0.3*(Pa-290)
end
Gf = 20;
Gr = 14;
Tbf = 2*Gf*Pf/12; %ft-lb
Tbr = 2*Gr*Pr/12; %ft-lb

fr = f0 + f1*((v*(60/88)/100)^2.5);
D = 0.5*(rho*Cd*A*(v.^2));

AA = zeros(5);

AA(1,:) = [W 0 0 1 1];
AA(2,:) = [0 1 1 0 0];
AA(3,:) = [W*h 0 L 0 0];
AA(4,:) = [If/R 0 fr*R 0 -R];
AA(5,:) = [Ir/R fr*R 0 -R 0];

rhs = [-D; W; W*b-D*h; -Tbf; -Tbr];

res = AA\rhs;

Dx = res(1);
Wr = res(2);
Wf = res(3);
Fbr = res(4);
Fbf = res(5);

dvdt = Dx*g;

f(1) = v;
f(2) = dvdt;

end







