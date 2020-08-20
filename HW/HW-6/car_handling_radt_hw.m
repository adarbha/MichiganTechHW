function f = car_handling_radt_hw(t,z)
global v delta
f = zeros(5,1);
x = z(1);
y = z(2);
si = z(3);
r = z(4);
beta = z(5);

g = 9.81; %m/s^2
M = 1500; %kg
I = 2400; %kg-m^2
a = 1.1; %m
b = 1.6; %m
L = a+b;
C_alphaf = 110*10^3;
C_alphar = 120*10^3;



W = M*g;
Wf = W*b/L;
Wr = W*a/L;
alpha_r = atan((-v*sin(beta)+r*b)/(v*cos(beta)));
alpha_f = delta - atan((v*sin(beta)+r*a)/(v*cos(beta)));
Ff = C_alphaf*alpha_f;
Fr = C_alphar*alpha_r;

drdt = (-Fr*b + Ff*cos(delta)*a)/I;
d_beta_dt = (Fr+Ff*cos(delta) + step_force(t,4000)*cos(si) - M*v*r*cos(beta))/(M*v*cos(beta));
f(1) = v*cos(si+beta);
f(2) = v*sin(si+beta);
f(3) = r;
f(4) = drdt;
f(5) = d_beta_dt;
end

