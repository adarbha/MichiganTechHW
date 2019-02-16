%purge and clean
clc;
clear all

%Parammeter initialization
dx = 0.1;
dt = 0.1;
alpha = 0.02; %m2/hr
L = 1; %meter
t = 10; %total time for which the simulation has to run
Co = 100; %deg.C
x = 0:dx:L; %spatial nodes
n = 0:dt:t; %temporal nodes

%T_FTemperature initialization
T_FT = zeros(length(n),length(x));

%FT_FTCS

for i = 1:length(n)
    for j = 2:length(x)-1
        if(i == 1)
            T_FT(i,j) = Co*sin(pi*x(j)/L);
        else
            T_FT(i,j) = T_FT(i-1,j) + alpha*(dt/(dx^2))*(T_FT(i-1,j-1)-2*T_FT(i-1,j)+T_FT(i-1,j+1));
        end
    end
end


    