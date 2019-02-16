clear all
clc

%FD parameters
nx = 20;
nt = 50;
dt = 0.01;
dx = 2/(nx-1);
x = [];

for i=1:nx
    if (x(i) <= 1 && x(i) >=50)
        u(i) = 2;
    else
        u(i) = 1;
    end
end

for it = 1:nt
    un = u;
    for i = 2:(nx-1)
        u(i) = un(i) - u(i)*(dt/dx)*(un(i)-un(i-1));
    end
end

        