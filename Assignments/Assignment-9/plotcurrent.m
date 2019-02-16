load idealcurrent.mat

figure
plot(i.time,i.signals.values,i.time,i.signals.values,i_ideal.time,i_ideal.signals.values)
ylabel('current (A)')
xlabel('time (s)')
legend('Battery A','Battery B','Current in Identical Cells')
title('Compare increased resistance to identical cells - current')
grid

load idealsoc.mat

figure
plot(SOC_A.time,SOC_A.signals.values,SOC_B.time,SOC_B.signals.values, SOC_ideal.time,SOC_ideal.signals.values)
ylabel('SOC')
xlabel('time (s)')
legend('Battery A','Battery B','Identical cells')
title('Compare reduced capacity to identical cells - SOC')
grid