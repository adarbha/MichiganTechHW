simu = [1 2 3 6];

figure(1)
hold on
plot(CA(:,1),P(:,1),'-r');
plot(CA(:,2),P(:,2),'-g');
plot(CA(:,3),P(:,3),'-b');
plot(CA(:,6),P(:,6),'-m');
title('Pressure v/s crank position')
xlabel('Crank Angle')
ylabel('Pressure(kpa)')
grid on
leg1 = legend('Cv','Cp','AHR-0','AHR-25');
hold off

for j=1:length(simu)
    V_max(j) = max(V(:,simu(j)));
end

for k = 1:length(simu)
    V_norm(:,k) = V(:,simu(k))/V_max(k);
end

figure(2)
hold on
plot(V_norm(:,1),P(:,1),'-r');
plot(V_norm(:,2),P(:,2),'-g');
plot(V_norm(:,3),P(:,3),'-b');
plot(V_norm(:,4),P(:,6),'-m');
title('Pressure v/s Volume')
xlabel('Volume(m^3)')
ylabel('Pressure(kPa)')
grid on
leg2 = legend('Cv','Cp','AHR-0','AHR-25');
hold off



figure(3)
hold on
plot(log(V_norm(:,1)),log(P(:,1)),'-r');
plot(log(V_norm(:,2)),log(P(:,2)),'-g');
plot(log(V_norm(:,3)),log(P(:,3)),'-b');
plot(log(V_norm(:,4)),log(P(:,6)),'-m');
title('loglog Pressure v/s Volume')
xlabel('Volume(m^3)')
ylabel('Pressure(kPa)')
grid on
leg3 = legend('Cv','Cp','AHR-0','AHR-25');
hold off



