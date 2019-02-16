% clear all
% clc

%Declaring constants for initial condition
dx = 0.2;
x = 0:dx:2*pi;
C = 0.5; %max - Courant number

% t = 0:dt:10;
u0 = 1;
A = 1;
len = length(x)+100;
%courant(1) = 0;
%Calculating temporal loop parameters 
dt = C*dx/2;
t = 0:dt:10;

u = ones(length(t),len);

u(1,1:length(x)) = u0 + A.*sin(x);


for n = 2:length(t)    
  for i = 2:(len-1)
        
        %LAX-WENDROFF
        u(n,i)=u(n-1,i)-((dt)/(4*dx))*(u(n-1,i+1)^(2)-u(n-1,i-1)^(2))+(dt^(2))/(4*dx^(2))*((u(n-1,i+1)+u(n-1,i))*0.5*(u(n-1,i+1)^(2)-u(n-1,i)^(2))-((u(n-1,i)+u(n-1,i-1))*0.5*(u(n-1,i)^(2)-u(n-1,i-1)^(2))));
        %upwind
%         u(n,i) = u(n-1,i) - (dt/dx)*((E(u(n-1,i)))-(E(u(n-1,i-1))));
        
    end
end


                   
% u(i,j)=u(i,j-1)-((dt)/(4*dx))*(u(i+1,j-1)^(2)-u(i-1,j-1)^(2))+(dt^(2))/(4*dx^(2))*((u(i+1,j-1)+u(i,j-1))*0.5*(u(i+1,j-1)^(2)-u(i,j-1)^(2))-((u(i,j-1)+u(i-1,j-1))*0.5*(u(i,j-1)^(2)-u(i-1,j-1)^(2))));
        