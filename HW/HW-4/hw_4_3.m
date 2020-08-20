


%Constants
rho = 0.00236; %lb-sec^2/ft^4
A = 2*(3.3^2); %ft^2
Cd = 0.35;
mu = 0.8;
g = 32.2;
W = 4074; %lb
%M = 4074/g; 
L = 108.5/12; %feet
a = 0.45*L;
b = 0.55*L;
h = 20.5/12; %feet
R = 12.11/12; %feet
If = 12/12; %feet-lb/sec^3
Ir = 13.5/12; %feet-lb-sec^3
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



AA = zeros(5);
RHS = [0; W; W*b; Tbf; Tbr];

AA(1,:) = [W 0 0 1 1];
AA(2,:) = [0 1 1 0 0];
AA(3,:) = [W*h 0 L 0 0];
AA(4,:) = [-(If/R)*g 0 0 0 R];
AA(5,:) = [-(Ir/R)*g 0 0 R 0];

res = AA\RHS;

Fbr = res(4)
Fbf = res(5)
Wf = res(3)
Wr = res(2)
Dx = res(1)
mu_f = Fbf/Wf
mu_r = Fbr/Wr
eff = Dx/max(mu_f,mu_r)



