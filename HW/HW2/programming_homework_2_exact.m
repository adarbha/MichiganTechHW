% clc;
% clear all;

%Parammeter initialization
dx = 0.1;
dt = 0.1;
alpha = 0.02; %m2/hr
L = 1; %meter
t = 10; %total time for which the simulation has to run
Co = 100; %deg.C
x = 0:dx:L; %spatial nodes
n = 0:dt:t; %temporal nodes

%Temperature initialization
T_exact = zeros(length(n),length(x));

for i = 1:length(n)
    for j = 1:length(x)-1
        T_exact(i,j) = Co*(exp(-alpha*(pi^2)*n(i)/(L^2)))*sin(pi*x(j)/L);
    end
end