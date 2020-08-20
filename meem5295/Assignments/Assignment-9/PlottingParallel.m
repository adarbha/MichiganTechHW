figure
subplot(3,1,1)
plot(VBattA.time,VBattA.signals.values,VBattB.time,VBattB.signals.values,VBatt_RL.time,VBatt_RL.signals.values)
ylabel('voltage (V)')
title('Identical Parallel Cells')
legend('Battery A Voltage','Battery B Voltage','Voltage calculated from Current')
grid

subplot(3,1,2)
plot(iA.time,iA.signals.values,iB.time,iB.signals.values)
ylabel('current (A)')
legend('Battery A current','Battery B current')
grid

subplot(3,1,3)
plot(SOC_A.time,SOC_A.signals.values,SOC_B.time,SOC_B.signals.values)
ylabel('state of charge')
xlabel('time (s)')
legend('Battery A SOC','Battery B SOC')
grid

load ideal.mat

figure
plot(VBattA.time,VBattA.signals.values,VBatt_Ideal.time,VBatt_Ideal.signals.values)
ylabel('voltage (V)')
xlabel('time (s)')
legend('Reduced Capacity in Batt A','Identical Batteries')
title('Compare increased resistance to identical cells- voltage')
grid

figure
plot(iA.time,iA.signals.values,iB.time,iB.signals.values,i_Ideal.time,i_Ideal.signals.values)
ylabel('current (A)')
xlabel('time (s)')
legend('Battery A','Battery B','Current in Identical Cells')
title('Compare increased resistance to identical cells - current')
grid

figure
plot(SOC_A.time,SOC_A.signals.values,SOC_B.time,SOC_B.signals.values, SOC_Ideal.time,SOC_Ideal.signals.values)
ylabel('SOC')
xlabel('time (s)')
legend('Battery A','Battery B','Identical cells')
title('Compare increased resistance to identical cells - SOC')
grid