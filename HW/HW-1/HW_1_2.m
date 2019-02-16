clc;
clear all;

F1 = 878; %lbs
F2 = 895;
F3 = 600;
F4 = 627;
W = F1 + F2 + F3 + F4;
Br = (F3+F4)/W;
Bl = (F1+F3)/W;
Bw = (F2+F3)/W;
L = 110; %inches
t = 62;
a = Br*L;
q = Bl*t;
dx = L/2 - a;
dy = t/2 - q;

%Let the bias mass be 100lbs

bm = 100; %Bias mass
y = (Bl-0.5)*(W*t)/bm; %Bias mass offset

%Reclaculating wedge bias

W_new = W + bm;
Bw_new = (F2+F3)/W_new;

