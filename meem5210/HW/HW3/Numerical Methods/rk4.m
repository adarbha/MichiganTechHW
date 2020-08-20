tic;
clc;
clear all;

%Parameters for initiating variables
h = 0.001; %step-size
t = 0:h:8;%Spatial variable
t_act = 0:0.001:8;
x(1) = 0; %intial position
v(1) = 0; %initial velocity
% x_e(1) = 0;
% v_e(1) = 0;

for i = 1:length(t)-1
  
  k1 = feval(@derivative1,x(i),v(i));
  l1 = feval(@derivative2,x(i),v(i));
  
  k2 = feval(@derivative1,x(i)+0.5*h*l1,v(i)+0.5*h*k1);
  l2 = feval(@derivative2,x(i)+0.5*h*l1,v(i)+0.5*h*k1);
  
  k3 = feval(@derivative1,x(i)+0.5*h*l2,v(i)+0.5*h*k2);
  l3 = feval(@derivative2,x(i)+0.5*h*l2,v(i)+0.5*h*k2);
  
  k4 = feval(@derivative1,x(i)+h*l3,v(i)+h*k3);
  l4 = feval(@derivative2,x(i)+h*l3,v(i)+h*k3);
  
  v(i+1) = v(i) + (h/6)*(k1+(2*k2)+(2*k3)+k4);
  x(i+1) = x(i) + (h/6)*(l1+(2*l2)+(2*l3)+l4);
  

end


k = 4;
m = 1;
f = 1;
B = 2*sqrt(m*k);
omega_n = sqrt(k/m);
zeta = B/(2*sqrt(m*k));
omega_d = omega_n*(sqrt(1-zeta^2));
phi = atan(zeta/sqrt(1-zeta^2));

%case1
for j=1:length(t_act)
    x_actual(j) = (f/k)*(1-(1+omega_n*t_act(j))*exp(-omega_n*t_act(j)));
%     x_actual(j) = (f/k)*(1-sqrt(1/(1-(zeta^2)))*exp(-zeta*omega_n*t_act(j))*cos(omega_d*t_act(j)-phi));
end

% plot(t,x,'-g',t_act,x_actual,'-r')
% leg1 = legend('RK4','Actual')
figure(1)
hold on
plot(t_act,x_actual,'-r')
plot(t,x,'-*')
xlabel('time(sec)')
ylabel('Response x(t)')
title('x v/s t')
leg1 = legend('actual','RK4');
grid on
hold off

%Error calculation
t_act = t;
for l = 1:length(t_act)
      x_actual1(l) = (f/k)*(1-(1+omega_n*t_act(l))*exp(-omega_n*t_act(l)));
%     x_actual1(l) = (f/k)*(1-sqrt(1/(1-(zeta^2)))*exp(-zeta*omega_n*t_act(l))*cos(omega_d*t_act(l)-phi));
    error(l) = abs((x_actual1(l) - x(l))*100/x_actual1(l));
end

% error = (x_actual1 - x)*100/x_actual1;
    
len = length(t_act);

figure(2)
plot(t_act(75:len),error(75:len),'-')
xlabel('time(s)')
ylabel('Absolute error(%)')
title('Absolute error v/s time')
grid on

toc;

time = toc




% Euler solution

% for m = 1:length(t)-1
% 
%     k1_e = feval(@derivative1,x_e(m),v_e(m));
%     l1_e = feval(@derivative2,x_e(m),v_e(m));
% 
%     v_e(m+1) = v_e(m) + h*k1_e;
%     x_e(m+1) = x_e(m) + h*v_e(m);
%     
% end
% 
% plot(t,x_e,'-g',t,x_actual,'-r')



