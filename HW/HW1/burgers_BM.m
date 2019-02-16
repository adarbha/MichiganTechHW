T = -100:100;
C = (T-32)*(5/9);
F = (9/5)*T + 32;

hold on
plot(T,C,'g');
plot(T,F,'r');
hold off