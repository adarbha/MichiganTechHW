% for g = 1:101
%     hold on
%     plot(x,T_FT(g,:))
%     hold off
% end

figure(1)
hold on
plot(x, T_FT(101,:),'-r')
plot(x, T_BT(101,:),'-b')
plot(x, T_CN(101,:),'-g')
plot(x, T_exact(101,:),'*')
xlabel('X(m)')
ylabel('Temperature degC')
hold off

error_FT = abs(T_exact - T_FT);
error_BT = abs(T_exact - T_BT);
error_CN = abs(T_exact - T_CN);

error_m = zeros(3,length(x));
error_m(1,:) = error_FT(101,:);
error_m(2,:) = error_BT(101,:);
error_m(3,:) = error_CN(101,:);

figure(2)
hold on
plot(x,error_m(1,:),'-r')
plot(x,error_m(2,:),'-b')
plot(x,error_m(3,:),'-g')
xlabel('X(m)')
ylabel('Absolute error')
hold off
