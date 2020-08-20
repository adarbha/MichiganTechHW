function [ v s ] = euler1(Ft_max_N, mass, power,weight_N, t)
%euler1 Summary of this function goes here
%   Detailed explanation goes here
%   h is the step size 
h = 100;
dt = 1/h;

v(t) = 0;
s(t) = 0;
a(t) = 0;
a(1) = Ft_max_N/mass;


for i=2:t*h
    if(i > 2 && (power/v(i-1)) < Ft_max_N) 
        a(i-1) = ((power/v(i-1))-(weight_N*0.01*(1+(v(i-1)/44.4)))-(0.5*1.2162*0.4*2.86*(v(i-1))^2))/mass;
    else
        a(i-1) = a(1);
    end
    v(i) = v(i-1) + dt*a(i-1);
    s(i) = s(i-1) + dt*v(i-1);
end

end

