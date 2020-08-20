options=odeset('reltol',1e-10,'abstol',1e-10);
global M I c fr r g Ta_max power omega_c vth
r=0.3;
vth=0.1;
M=400;
I=1.2;
g=9.81;
fr=.1;
c=100;
Ta_max=1320;
omega_c=50;
power=Ta_max*omega_c;
[t,z]=ode23s(@tire_test_lecture_7,[0,.3],[0,0,0]);
figure(1)

plot(t,z(:,1),t,z(:,3),'*')
title('velocities')
grid
figure(2)

plot(t,z(:,2),t,z(:,3)/.3,'*')
title('omegas')
grid
figure(3)

plot(t,slipx(z(:,1),z(:,2),.3,.1))
title('slip')
grid
figure(4)

slipx_in=slipx(z(:,1),z(:,2),.3,.1);
Ta=zeros(length(t),1);
for i=1:length(t)
    v=z(i,3);
    if v/r<=omega_c
    Ta(i)=Ta_max;
    else
    Ta(i)=power/(v/r);
    end
end

f=c*z(:,3).^2+M*(Ta/r-fr*M*g-c*z(:,3).^2)/(M+I/r^2);
plot(t,tire1(slipx_in)*400*9.81,t,f);
title('tire force')
grid

