g = 32.2;
%M = 4074; %lb
W = 4074; 
L = 108.5/12; %feet
a = 0.45*L;
b = 0.55*L;
h = 20.5/12; %feet
R = 12.11/12; %feet
mu = 0.8;
mu_ice = 0.3;

Fbr = 0:1:2500;
Fbfm = ((mu*W*b/L) + (mu*h*Fbr)/L)/(1-(mu*h/L));
Fbfm_ice = ((mu_ice*W*b/L) + (mu_ice*h*Fbr)/L)/(1-(mu_ice*h/L));


Fbf = 0:1:2500;
Fbrm = ((mu*W*a/L) - (mu*h*Fbf)/L)/(1+(mu*h/L));
Fbrm_ice = ((mu_ice*W*a/L) - (mu_ice*h*Fbf)/L)/(1+(mu_ice*h/L));

A_f = [0 692.33 990.34 2017.41 2348.21];
A_r = [0 483.04 689.75 901.82 969.67];

hold on
plot(Fbrm,Fbf)
plot(Fbr,Fbfm)
plot(Fbrm_ice,Fbf)
plot(Fbr,Fbfm_ice)
plot(A_r(1:5),A_f(1:5))
hold off