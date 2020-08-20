clc;
clear all;


t = 0:0.01:8; %time-domain
k = 4;
m = 1;
f = 1;
B = 0.3*sqrt(m*k);
omega_n = sqrt(k/m);
zeta = B/(2*sqrt(m*k));
omega_d = omega_n*(sqrt(1-zeta^2));
phi = atan(zeta/sqrt(1-zeta^2));

%case1
for i=1:length(t)
    x_actual(i) = (f/k)*(1-(1/sqrt(1-zeta^2))*exp(-zeta*omega_n*t(i))*cos(omega_d*t(i)-phi));
end



%case2

for j = 1:length(t)
    X(j) = (f/k)*(1-(1+omega_n*t(j))*exp(-omega_n*t(j)));
end

plot(t,x)