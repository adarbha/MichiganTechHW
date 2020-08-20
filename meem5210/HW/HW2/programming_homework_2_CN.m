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

%T_CNemperature initialization
T_CN = zeros(length(n),length(x));

%parameter initialisation for solving the tridiag matrix
A = alpha*dt/(2*(dx^2));
B = 1 + (alpha*dt/(dx^2));

B1 = repmat(-B,1,length(x)-2);
A1 = repmat(A,1,length(x)-3);

M_matrix = diag(B1) + diag(A1,-1) + diag(A1,1);

%T_CNemperature initialisation
T_CN = zeros(length(n),length(x));

K = zeros(length(x)-2,1);


for i=1:length(n)
    for j=2:length(x)-1
        if (i == 1)
            T_CN(i,j) = Co*sin(pi*x(j)/L);
        else
            K(j-1,1) = T_CN(i-1,j)*(2*A-1)-A*T_CN(i-1,j+1)-A*T_CN(i-1,j-1);
        end
    end
    if(i ~= 1)
        K(1,1) = K(1,1) - A*T_CN(i-1,1);
        K(length(x)-2,1) = K(length(x)-2,1) - A*T_CN(i-1,length(x));
        new_T_CN = M_matrix\K;
        T_CN(i,2:length(x)-1) = new_T_CN;
    end
    
end






