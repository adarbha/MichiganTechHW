clear all;
pi2=2*pi;
pi2ov99=pi2/99;
time = [0.0 0.5 1.0 1.5 2.0 3.0 4.0 6.0 8.0 10.0];
%+++
%+++ setup initial condition
%+++
x = 0 : pi2ov99 : pi2;
for i = 1:100
%    x(i) = (i-1)*pi2ov100;
    uplot(i,1) = 1+sin(x(i));
    xplot(i,1) = x(i);
end
%+++
%+++ time loop j and spatial loop i
%+++
for j = 2:10
    t = time(j);
%+++
%+++ Spatial loop, 1st half 1 <= i < 50 (forward search)
%+++
    u0=uplot(1,j-1);
    for i = 1:49
        xi=xplot(i,1)+t;
        while abs(1+sin(xi-u0*t)-u0) > 1.0e-6
          uiter=nroot(xi,t,u0);
          u0=uiter;
        end
        uplot(i,j)=u0;
        xplot(i,j)=xi;
    end
%+++
%+++ Spatial loop, 2nd half 50 <= i <= 100 (backward search)
%+++
    u0=uplot(100,j-1);
    for i = 100:-1:50
        xi=xplot(i,1)+t;
        while abs(1+sin(xi-u0*t)-u0) > 1.0e-6
          uiter=nroot(xi,t,u0);
          u0=uiter;
        end
        uplot(i,j)=u0;
        xplot(i,j)=xi;
    end
end
plot(xplot(:,1),uplot(:,1),xplot(:,2),uplot(:,2),...
     xplot(:,3),uplot(:,3),xplot(:,4),uplot(:,4),...
     xplot(:,5),uplot(:,5),xplot(:,6),uplot(:,6),...
     xplot(:,7),uplot(:,7),xplot(:,8),uplot(:,8),...
     xplot(:,9),uplot(:,9),xplot(:,10),uplot(:,10))
axis([0 pi2+10 0 2])
grid on