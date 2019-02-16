global v delta
v = 60*5/18;
delta = 0;
[t1 z1] = ode45(@car_handling_radt_hw,[0,4],[0; 0; 0; 0; 0]);

figure(1)
plot(t1,z1(:,3),'r');
xlabel('time')
ylabel('yaw')
grid


figure(2)
plot(t1,z1(:,5),'b');
xlabel('time')
ylabel('side slip')
grid

figure(3)
R = abs(v/z1(length(t1),4))
ay = (v^2)/(R*32.2)
plot(z1(:,2),z1(:,1))
xlabel('y')
ylabel('x')
axis equal