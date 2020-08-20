%purge and clean
clc;
clear all;

%Setting parameters for Newton Raphson
error = 100;
tol = 1e-5;

%Parameters for the Burger's equation
A = 1;
u0 = 1;
t = [0 0.5 1 1.5 2 3 4 6 8 10];
x = 0:0.1:2*pi;
u = zeros(length(t),length(x));

% for p = 1:length(t)
%     for q = 1:length(x)
%         u(p,q) = sin(x(q));
%     end
% end


for i = 1:length(t)
    for j = 1:length(x)
        if(i == 1)
            u(i,j) = u0 + A*sin(x(j)); %Declaration of Initial conditions
        %u(i-1,j)
        else  % Newton Raphson goes here
%             u(i-1,j)
%             x(j)
%             t(i)
              p = u(1,j)
              q = x(j)+u(i-1,j)*(t(i)-t(i-1))
              u(i,j) = bisection(@test,p,p+0.1,tol,q,t(i));
        end
        j = j+1;
    end
    i = i+1;
end

            
            



