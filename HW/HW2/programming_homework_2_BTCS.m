%purge and clean
% clc;
% clear all

%Parammeter initialization
dx = 0.1;
dt = 0.1;
alpha = 0.02; %m2/hr
L = 1; %meter
t = 10; %total time for which the simulation has to run
Co = 100; %deg.C
x = 0:dx:L; %spatial nodes
n = 0:dt:t; %temporal nodes

%parameter initialisation for solving the tridiag matrix
A = -alpha*dt/(dx^2);
B = repmat((1-2*A),1,length(x)-2);
C = repmat(A,1,length(x)-3);

%Creating a 9*9 tridiagonal matrix
M_matrix = diag(B) + diag(C,-1) + diag(C,1);


%Initialisation of temperature
T_BT = zeros(length(n),length(x));
K = zeros(length(x)-2,1);


for i = 1:length(n)
    a = [];
    for j = 2:length(x)-1
        if (i == 1)
            T_BT(i,j) = Co*sin(pi*x(j)/L);
        else
            a = [a, T_BT(i-1, j)];
        end
    end
    if (i ~= 1)
    K = transpose(a);
    new_T_BT = M_matrix\K;
    T_BT(i,2:length(x)-1) = new_T_BT;
    end
    
end







