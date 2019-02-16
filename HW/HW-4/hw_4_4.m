
%Constants
rho = 0.00236; %lb-sec^2/ft^4
A = 2*(3.3^2); %ft^2
Cd = 0.35;
mu = 0.8;
g = 32.2;
M = 4074; %lb
W = 4074*g; 
Wf = 0.55*M;
Wr = 0.45*M;
L = 108.5/12; %feet
a = 0.45*L;
b = 0.55*L;
h = 20.5/12; %feet
R = 12.11/12; %feet
If = 12/12; %feet-lb/sec^3
Ir = 13.5/12; %feet-lb-sec^3
f0 = 0.013;
f1 = 6.5e-7;
mu_p = 0.8;

Fxr = 0:0.1:10000;
Fxf = 0:0.1:10000;

A = 1-(mu_p*(h/L));

B = 1+(mu_p*(h/L));

F_xmf = mu_p*(Wf + ((h/L)*Fxr))/A;
F_xmr = mu_p*(Wr - ((h/L)*Fxf))/B;

hold on
plot(Fxr,F_xmf)
plot(Fxf,F_xmr)
hold off

