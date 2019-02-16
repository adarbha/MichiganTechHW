clc;
clear all;

%Parameters for initiating Heun's method
y(1) = 1;
h = 0.1; %step-size
x = 0:h:1;%Spatial variable
x(length(x)+1) = x(length(x)) + h;

for i = 2:length(x)-1
    y1 = y(i-1) + h*feval(@derivative,x(i),y(i-1));
    new_slope = feval(@derivative,x(i+1),y1);
    y(i) = y(i-1) + 0.5*h*(feval(@derivative,x(i),y(i-1)) + new_slope);
end


for j = 1:length(x)-1
    y_exact(j) = (1/3)*(exp(-2*x(j)) + 2*exp(-5*x(j)));
end


plot(x(1:11),y,'-r',x(1:11),y_exact,'-g')
