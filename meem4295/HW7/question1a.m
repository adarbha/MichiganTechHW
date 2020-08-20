clear all
clc

%Defining the Variables

BMEP_Tmax = 900;
T_max = 400;
w_Tmax_rpm = 4100;
nR = 2;
N = 4;

w_Tmax_rps = w_Tmax_rpm/60;
vd = (6.28*nR*T_max)/(BMEP_Tmax);

L = 10;

for L = 150:-1:100
    
    n(151-L) = ((vd*1000000)/(pi*(L^3)))^0.5
    sp(151-L) = 0.13666*L;
    %if (n <= 1.1 && n >=0.9) && (sp <= 18 && sp >= 8)
    %    break
    %end
  
    
end

B = n*L
        
  figure(1)
    plot(n)
    figure(2)
    plot(sp)

