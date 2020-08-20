function [ s ] = euler( velocity )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n = length(velocity);
s1(1) = 0;
dt = 0.1;
s(1) = 0;

for i = 1:n-1
    vel_split = linspace(velocity(i),velocity(i+1),1/dt);
    for j = 2:10
        s1(j) = s1(j-1) + vel_split(j-1)*dt;
    end
    s(i+1) = s1(10);
    s1(1) = s1(10);
end
        

end

