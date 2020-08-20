%Euler numerical scheme
%derivative function derivative f(y,t) has to be defined in the work-space)

clear all;
clc;

%Initialisation of parameters
y(1) = 0; %Initial value
t = 5; %total time
h = 0.001; %step-size
t_initial = 0; % start from this time
t1 = 0:h:t;

for i=2:length(t1)
    y(i) = y(i-1) + h*feval(@derivative,y(i-1),t1(i-1));
end


%Actual function
%% Make necessary changes
for j=1:length(t1)
    y_actual(j) = exp(t1(j)/2)*sin(5*t1(j));
end

plot(t1,y,'-r',t1,y_actual,'-g')