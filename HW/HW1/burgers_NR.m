%purge and clean
clc;
clear all;

%Setting parameters for Newton Raphson
error = 1;
tol = 1e-10;


%Parameters for the Burger's equation
A = 1;
u0 = 1;
%t = [0 0.5 1 1.5 2 3 4 6 8 10];
t = 1:0.2:10;
x = 0:0.1:2*pi;
u = zeros(length(t),length(x));
q = 0;

for i = 1:length(t)
    for j = 2:length(x)
        if(i == 1)
            u(i,j) = u0 + A*sin(x(j)); %Declaration of Initial conditions
        %u(i-1,j)
        else  % Newton Raphson goes here
%             u(i-1,j)
%             x(j)
%             t(i)
              q = x(j)+u(i-1,j)*(t(i)-t(i-1));
              u(i,j) = newton_raphson1(@test,@dtest,u(i,j-1),q,t(i));
        end
        j = j+1;
    end
    i = i+1;
end

            
            



