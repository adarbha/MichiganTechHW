function f = car_handling_radt(t,z)
global v delta
f = zeros(5,1);
x = z(1);
y = z(2);
si = z(3);
r = z(4);
beta = z(5);

g = 32.2;
M = 3500/g;
I = 1887;
a = 40/12;
b = 60/12;
L = a+b;

mu = 1.1;
ahat = 0.29;
bhat = 5.5e-05;

W = M*g;
Wf = W*b/L;
Wr = W*a/L;
alpha_r = atan((-v*sin(beta)+r*b)/(v*cos(beta)));
alpha_f = delta - atan((v*sin(beta)+r*a)/(v*cos(beta)));
Ff = 2*radt(alpha_f*57.3,Wf/2,mu,ahat,bhat);
Fr = 2*radt(alpha_r*57.3,Wr/2,mu,ahat,bhat);

drdt = (-Fr*b + Ff*cos(delta)*a)/I;
d_beta_dt = (Fr+Ff*cos(delta) - M*v*r*cos(beta))/(M*v*cos(beta));
f(1) = v*cos(si+beta);
f(2) = v*sin(si+beta);
f(3) = r;
f(4) = drdt;
f(5) = d_beta_dt;
end

