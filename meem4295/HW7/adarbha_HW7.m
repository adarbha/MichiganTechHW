clc;
clear all;





%--------------------------Solution 1b----------------------------------%

BMEP_kpa_b = 700; %this is bmep at max torque
BMEP_kpa_Pmax_b = 0.9*BMEP_kpa_b; %taking bmep at max power to be equal to 90% of BMEP at max torque
Pmax_b = 250;

%Assuming the length to be 80mm and b/l ratio to be equal to 1.1
%The value of length is obtained iteratively by so that bore diameter
%obtained at the end of all calculations falls within the ratio specified
%and in this case b/l is close to 1.1

Sp_max_b = 10;

Length_mm_b =200;

%Assuming Spmax to be 10m/s and number of cylinders to be 12
%Performing 1000000 iterations just to make sure the solution converges
%before 1000000

for i = 1:125

RPS_Pmax_b = Sp_max_b/(2*Length_mm_b/1000);
Vol_d_dm3_b = (1000*2*Pmax_b)/(BMEP_kpa_Pmax_b*RPS_Pmax_b);

Bore_mm_b = ((Vol_d_dm3_b/(12*(pi/4)*1.15))^0.5)*100;
q(i) = Bore_mm_b/Length_mm_b;



%if q <= 1.1 && q >= 0.9
%    break
%end

Length_mm_b = Length_mm_b-1;

end

%plot(q)

Length_mm_a =75;

%Assuming Spmax to be 10m/s and number of cylinders to be 12
%Performing 1000000 iterations just to make sure the solution converges
%before 1000000

for j = 1:125

RPS_Pmax_a = Sp_max_b/(2*Length_mm_a/1000);
Vol_d_dm3_a = (1000*2*Pmax_b)/(BMEP_kpa_Pmax_b*RPS_Pmax_a);

Bore_mm_a = ((Vol_d_dm3_a/(12*(pi/4)*1.15))^0.5)*100;
p(j) = Bore_mm_a/Length_mm_a;



%if q <= 1.1 && q >= 0.9
%    break
%end

Length_mm_a = Length_mm_a+1;

end

hold on
plot(p,'r')
plot(q,'g')
hold off


%Torque at max speed

T_at_max_speed = BMEP_kpa_Pmax_b*Vol_d_dm3_b/(6.28*2);

%Let the sfc of the engine be 200g/KWh

Mass_flowrate = 200*Pmax_b;












