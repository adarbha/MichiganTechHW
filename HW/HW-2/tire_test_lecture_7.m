function f=tire_test_lecture_7(t,z)
global M I c fr r g Ta_max power omega_c vth
f=zeros(3,1);
v=z(1);
omega=z(2);
v_rolling=z(3);

% r=0.3;
% M=400;
% I=1.2;
% g=9.81;
% fr=.1;
% c=100;

N=M*g;


%tires

vth=0.1;
if abs(v)>vth
    slipx=(omega*r-v)/abs(v);
else
    slipx=2*(omega*r-v)/(vth+v^2/vth);
end

if omega<=omega_c
    Ta=Ta_max;
else
    Ta=power/omega;
end
f(1)=(-c*v^2+tire1(slipx)*N)/M;
f(2)=(Ta-fr*N*r-tire1(slipx)*N*r)/I
if v_rolling/r<=omega_c
    Ta=Ta_max;
else
    Ta=power/(v_rolling/r);
end
f(3)=(Ta/r-fr*N-c*v_rolling^2)/(M+I/r^2);

tire1(slipx)*N