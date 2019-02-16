clear all
clc

%Declaring constants for initial condition
dx = 0.1;
x = 0:dx:2*pi;
dt = 0.005;
t = 0:dt:10;
u0 = 1;
A = 1;
len = length(x)+100;

% u = ones(length(t),length(x));
% u(1,:) = u0 + A.*sin(x);
u = ones(length(t),len);
u(1,1:length(x)) = u0 + A.*sin(x);

for n = 2:(length(t))
    for i = 2:(length(x)-1)
       %u(n,i) = u(n-1,i) - (dt/(2*dx))*(E(u(n-1,i+1))+E(u(n-1,i-1)) - (abs(u(n-1,i+1)-u(n-1,i)))*(u(n-1,i+1)-u(n-1,i)) + (abs(u(n-1,i)-u(n-1,i-1)))*(u(n-1,i)-u(n-1,i-1)));
       
       if u(n-1,i) ~= u(n-1,i+1)
           vhalfjplus = (dt/dx)*0.5*(u(n-1,i+1)*u(n-1,i));
       else
           vhalfjplus = (dt/dx)*u(n-1,i);
       end
       
 
       hhalfjplus = 0.5*((0.5*u(n-1,i+1)^2)+(0.5*u(n-1,i)^2)-vhalfjplus*((0.5*u(n-1,i+1)^2)-(0.5*u(n-1,i)^2)));
  
       
       if u(n-1,i-1) ~= u(n-1,i)
           vhalfjminus = (dt/dx)*(0.5)*(u(n-1,i)+u(n-1,i-1));
       else
           vhalfjminus = (dt/dx)*(u(n-1,i-1));
       end
       
       hhalfjminus = 0.5*((0.5*u(n-1,i)^2)+(0.5*u(n-1,i-1)^2)-vhalfjminus*((0.5*u(n-1,i)^2)-(0.5*u(n-1,i-1)^2)));
       
       u(n,i) = u(n-1,i-1) - (dt/dx)*(hhalfjplus - hhalfjminus);
       %Lax - Wentchofff
        %u(n,i) = u(n-1,i) + ((dt/(2*dx))*((u(n-1,i-1)^2) - (u(n-1,i+1)^2))) + ((dt^2)/2*(dx^2))*(0.5*(u(n-1,i+1)+u(n-1,i))*(E(u(n-1,i+1))-E(u(n-1,i))) - 0.5*(u(n-1,i-1)+u(n-1,i))*(E(u(n-1,i))-E(u(n-1,i-1))));
       courant = u(n,i)*(dt/dx);
       if courant > 1
           break
       end
    end
end

% t_plot = [51 101 151 201 301 401 601 801 1001];

for j = 1:10:1000
    hold on
    plot(u(j,:))
end


