function knock_sim

%   This function calculates the knock index for an air standard arbitrary
%   heat release cycle.  Based on the method as described by Heywood (1988).  
%
%   KMF     April 27/05 Rev 1
%

global eng_p input

[P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,X]=air_standard;

ON = str2double(inputdlg('Enter Fuel Octane Number','Octane Number',1,{'87'}));
RPM = eng_p(4);

ts = str2double(get(input(25,2),'String'));  %Get ts value
tb = str2double(get(input(26,2),'String'));  %Get tb value

ts=ts*pi/180;        %spark timing in radians ABDC (160°ABDC = 20°BTDC)
tb=tb*pi/180;          %combustion duration in radians (50°)

max_theta_k = ts + 2/3*tb  %After this angle, 75% of fuel is burned

i = 1;
while theta_main(i) <= max_theta_k
    theta_knock(i) = theta_main(i);
    i = i+1;
end

time = 30000/(pi*RPM)*(theta_knock+pi)

ind_time = 17.68*(ON/100)^3.402.*(P_main(1:length(theta_knock))/101.325).^-1.7.*...
           exp(3800./T_main(1:length(theta_knock)));
y = 1./ind_time
knock_index = trapz(time,y)/15;
figure;
plot(time,y)
title('Inverse of Induction Time');
xlabel('Time (msec)');
ylabel('1/Tau');


if knock_index <= 1
    msgbox(['No knock will occur under these conditions - Knock index = '...
        num2str(knock_index)]);
else
    errordlg(['Knock could occur under these conditions - Knock index = '...
        num2str(knock_index)]);
end