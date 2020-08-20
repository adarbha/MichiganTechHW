%Engine Parameters

Vd = 0.482e-3; %m^3 of volume displaced 
N = 3000/60; %rps
N_cyl = 4;

%Calculating difference in velocities
dV = diff(V);
for(i = 1:size(P,2))
    dW(:,i) = P(1:720,i).*dV(:,i);
end

Work_c = sum(dW); %kJ

%Average torque per cycle

Torque_c = Work_c/(4*pi); % kNm

%Mean effective pressure

MEP_bar = (Work_c/Vd)*0.01;

%Power of the engine

Power_hp = (Work_c*N*N_cyl/2)*1.34;

%Heat-input calculation

Heat_kJ = Work_c(1)/0.56;

efficiency = Work_c(2:length(Work_c))/Heat_kJ;

%Torque calculations

T = zeros(1441,9);




for(j = 1:size(P,2))
    T(1:360,j) = (1000*100*(Vd/360)/(0.5*pi/180));
    T(361:1080,j) = 1000*dW(:,j)/(0.5*pi/180);
    T(1081:1440,j) = -(1000*100*(Vd/360)/(0.5*pi/180));
end

CA_new = -360:0.5:360;

figure(1)
hold on
plot(CA_new,T(:,1),'-r');
plot(CA_new,T(:,2),'-g');
plot(CA_new,T(:,3),'-b');
plot(CA_new,T(:,6),'-m');
title('Torque v/s Crank Angle')
xlabel('Crank Angle(degrees)')
ylabel('Torque(N-m)')
grid on
leg4 = legend('Cv','Cp','AHR-0','AHR-25');
hold off





