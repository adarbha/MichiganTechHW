clc;
clear all;

load = [225 450 675 900 1125 1350];
cs = [67 121 171 225 257 300];
cc = cs./load;
A = [load.^2',load'];
b_a = ((A'*A)\(A'*cs'))'
b_a = [b_a, 0];
cs_f = polyval(b_a,1901/2)
cs_r = polyval(b_a,1552/2)
cal_cs_1 = polyval(b_a,load);

b_a = polyfit(load,cc,1);
b_a = [b_a, 0];
cal_cs_2 = polyval(b_a,load);
cs_f = polyval(b_a,1901/2)
cs_r = polyval(b_a,1552/2)
% plot(load,cs,'*',load,cal_cs_1,'r',load,cal_cs_2,'b')

cs_f = interp1(load,cs,1901/2)
cs_r = interp1(load,cs,1552/2)



%Static Margin calculation
L = 100/12; %feet

W = 3400;
a = 2:0.01:6.5;


for i = 1:length(a)
    b(i) = L-a(i);

    Wf = W*b(i)/L;
    Wr = W*a(i)/L;


    cs_f_p = polyval(b_a,Wf/2);
    cs_r_p = polyval(b_a,Wr/2);

    e = (cs_r_p.*b(i) - cs_f_p.*a(i))/(cs_f_p+cs_r_p);

    SM(i) = e*100/L
end



hold on
plot(a,SM,'-b')
p = polyfit(SM,a,1);
for k = 1:length(a)
    SM_new(k) = polyval(p,a(k))
end
% plot(a,SM_new,'r')
plot(4.17,0,'*')
text(4.17,1,'4.17,0')
plot(3.78,1,'*')
text(3.78,2,'3.78,1')
plot(4.55,-1,'*')
text(4.55,-2,'4.55,-1')
xlabel('a')
ylabel('percentage SM')
grid on
hold off









