%% Specify the Generic Test Cycle
%
% Need to specify Vehicle time (s) and Vehicle Speed in (mph)

close all;
clc

clear TEST_CYCLE


T_MAX =  1000;         % Duration in sec of the test cycle 
T_INT =    50;         % Interval for changing speeds

V_MAX =    75;         % Maximum Vehicle Speed
V_MIN =     0;

T    = 0:T_INT:T_MAX;    % (sec)

VS   =  V_MIN +(V_MAX-V_MIN).*rand(size(T));

TIME    = 0:1:T_MAX;     % (sec)
VS   = interp1(T, VS, TIME, 'nearest');

% Modify this as desired
VS(VS<9) = 0;
VS(1:20) = 0;

% Reducing the second filter parameter will smooth out / reduce the 
% transients nominal of 0.1
[b,a] = butter(1, 0.1);
VS = filter(b,a,VS);

% Plot results
figure; 
    set(gcf, 'position', [50 50 900 600]);
    h = plot(TIME, VS, 'r');
        set(h, 'linewidth', 2);
        set(gca, 'fontsize', 16, 'fontname', 'Calibri');
        xlabel('Time (sec)');
        ylabel('Vehicle Speed (mph)');
        grid on;

 TEST_CYCLE(:,1) = TIME;
 TEST_CYCLE(:,2) = VS;

%%
%save GENERIC_Cycle.mat TEST_CYCLE
    

