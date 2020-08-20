%test 623

theta = -15:0.01:20;
figure
hold on
p1=plot(theta,wiebe(theta,-15,14,3.2,2.303),'.-r'); 
p2=plot(-20:20,MFB_623(40:80))
set(p1,'LineWidth',2)
set(p2,'LineWidth',2)
set(gca,'fontname','Calibri','fontsize',20,'LineWidth',2)
legend('Wiebe','Data')
xlabel('Engine Position(CAD)')
ylabel('MFB(-)')
grid
hold off

%test 626

theta = -15:0.01:20;
figure
hold on
p1=plot(theta,wiebe(theta,-22,17.8,3.6,2.303),'.-r'); 
p2=plot(-20:20,MFB_626(40:80))
set(p1,'LineWidth',2)
set(p2,'LineWidth',2)
set(gca,'fontname','Calibri','fontsize',20,'LineWidth',2)
legend('Wiebe','Data')
xlabel('Engine Position(CAD)')
ylabel('MFB(-)')
grid

% test 631
theta = -15:0.01:20;
figure
hold on
p1=plot(theta,wiebe(theta,-30,17.3,3.7,2.303),'.-r'); 
p2=plot(-20:20,MFB_631(40:80))
set(p1,'LineWidth',2)
set(p2,'LineWidth',2)
set(gca,'fontname','Calibri','fontsize',20,'LineWidth',2)
legend('Wiebe','Data')
xlabel('Engine Position(CAD)')
ylabel('MFB(-)')
grid


