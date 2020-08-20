% newx = (max(x)+dx):dx:(max(x)+dx*100);
% x = [x newx];

% for j = 1:50:364
%     hold on
%     plot(u(j,:))
% end
%t_plot = [0.25 0.5 1.0 5.0 10.0 20.0];

hold on
plot(x,(u(round(0/dt)+1,:)),'-b');
plot(x,(u(round(0.5/dt)+1,:)),'-m');
plot(x,(u(round(1.0/dt)+1,:)),'-k');
plot(x,(u(round(2.0/dt)+1,:)),'-y');
plot(x,(u(round(6.0/dt)+1,:)),'-r');
plot(x,(u(round(10.0/dt),:)),'-g');
plot(xplot(:,1),uplot(:,1),'--b')
plot(xplot(:,2),uplot(:,2),'--m')
plot(xplot(:,3),uplot(:,3),'--k')
plot(xplot(:,4),uplot(:,4),'--y')
plot(xplot(:,8),uplot(:,8),'--r')
plot(xplot(:,10),uplot(:,10),'--g')
hold off

grid on
xlabel('x')
ylabel('f(x)')
title('TVD C=0.25')

leg1 = legend('tu=0s','tu=0.5s','tu=1.0s','tu=2.0s','tu=6.0s','tu=10.0','ta=0s','ta=0.5s','ta=1.0s','ta=2.0s','ta=6.0s','ta=10.0');

  

