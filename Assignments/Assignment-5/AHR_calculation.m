% Test 623
CA_TRANS = 4.5;
N_TRANS  = 10;
g = ones(size(CA_623));
g(CA_623<CA_TRANS)  = 1.366;
g(CA_623>=CA_TRANS) = 1.284;
b = ones(1,N_TRANS);
b = b/sum(b);
g = filtfilt(b,1,g);
g = 0.94*g;
clear b

g_avg = mean(reshape(g(ii),720,301),2);
Q = AHR(P_R_623_avg*1e03,V_avg,g_avg,CA_180_mean);
Q = Q(120:260);
cum_sum = cumsum(Q);
MFB_623 = cum_sum./max(cum_sum);
hold on
p=plot(-60:80,Q)
set(p,'LineWidth',2)

%Test 626
CA_TRANS = 4.5;
N_TRANS  = 10;
g = ones(size(CA_626));
g(CA_626<CA_TRANS)  = 1.366;
g(CA_626>=CA_TRANS) = 1.284;
b = ones(1,N_TRANS);
b = b/sum(b);
g = filtfilt(b,1,g);
g = 0.94*g;
clear b

g_avg = mean(reshape(g(ii),720,301),2);
Q = AHR(P_R_626_avg*1e03,V_avg,g_avg,CA_180_mean);
Q = Q(120:260);
cum_sum = cumsum(Q);
MFB_626 = cum_sum./max(cum_sum);
p=plot(-60:80,Q,'r')
set(p,'LineWidth',2)

%Test 631
CA_TRANS = 4.5;
N_TRANS  = 10;
g = ones(size(CA_631));
g(CA_631<CA_TRANS)  = 1.366;
g(CA_631>=CA_TRANS) = 1.284;
b = ones(1,N_TRANS);
b = b/sum(b);
g = filtfilt(b,1,g);
g = 0.94*g;
clear b

g_avg = mean(reshape(g(ii),720,301),2);
Q = AHR(P_R_631_avg*1e03,V_avg,g_avg,CA_180_mean);
Q = Q(120:260);
cum_sum = cumsum(Q);
MFB_631 = cum_sum./max(cum_sum);
p=plot(-60:80,Q,'g')
set(p,'LineWidth',2)

grid
legend('Test 623','Test 626','Test 631')
set(gca,'fontname','Calibri','fontsize',20,'LineWidth',2)
xlabel('Engine Position(CAD)')
ylabel('AHR(J/deg)')
hold off

figure
p2 = plot(-60:80,MFB_623,-60:80,MFB_626,'-r',-60:80,MFB_631,'g')
set(gca,'fontname','Calibri','fontsize',20,'LineWidth',2,'XLim',[-30 40])
legend('Test 623','Test 626','Test 631')
set(p2,'LineWidth',2)
xlabel('Engine Position (CAD)')
ylabel('MFB(-)')
grid

