function cycle_calc

%   Function to extract all required outputs from Engine_sim
%
%   Calls cycle_preview to perform all necessary calculations.  Creates a 
%   matrix of values for up to 12 runs to be exported to the
%   cycle_output.xls spreadsheet.  Also displays a P-v diagram and P-theta
%   diagram for up to 6 runs.  
%   Callback for calc button in Engine_sim.
%
%   KMF     April 27/05 Rev 1



global bgrnd txtcolor p_v eng_sim eng_p option input input_f clear_run
global P_ma v_ma T_ma theta_ma P_pa v_pa theta_pa output_f X_f
global vol_eff I_p isfc m_dot_fa m_dot_fuel m_dot_air 
%Call cycle_preview to perform calculations

figure(eng_sim)

run = str2double(inputdlg('Enter Run Number','Run Number',1));

if run > 12
    errordlg('The maximum number of runs allowed is 12');
    return;
end

if clear_run == 1
%Clear all run variables
P_ma = [];
v_ma = [];
T_ma = [];
theta_ma = [];
P_pa = [];
v_pa = [];
theta_pa = [];
output_f = [];
X_f = [];
vol_eff = [];
I_p = [];
isfc = [];
m_dot_fa = [];
m_dot_fuel = [];
m_dot_air = [];
input_f = [];
end
clear_run = 0;

[P_m,v_m,T_m,theta_m,P_p,v_p,theta_p,output_final,X_final] = cycle_preview;
P_ma(:,run) = P_m';
v_ma(:,run) = v_m';
T_ma(:,run) = T_m';
theta_ma(:,run) = theta_m';
P_pa(:,run) = P_p';
v_pa(:,run) = v_p';
theta_pa(:,run) = theta_p';
output_f(:,run) = output_final';
X_f(:,2*run-1) = X_final(:,1);
X_f(:,2*run) = X_final(:,2);
fa = output_f(13,run);
f = output_f(12,run);
% %Start new calculation figure
% cyc_calc = figure;
% output_final
% 
% size = get(0,'Screensize');
% width = size(3);
% height = size(4);
% 
% %Set window parameters
% 
% set(cyc_calc,'numbertitle','off','name','Cycle Calculations');
% set(cyc_calc,'outerposition',[1 1 width height],'color',bgrnd);
% 

%Get parameters for calculating volumetric efficiency, etc

[Tatm,Patm,Tinit,Pinit,M,vinit,rc,step,R,thetainit,thetafinal,re,Pfinal]=get_parameters;


%Basic engine calculations

displacement(1,run) = pi/4*(eng_p(1)/1000)^2*(eng_p(2)/1000)*eng_p(3);
m_p_speed(1,run) = 2* eng_p(2)/1000 * eng_p(4)/60;  %mean piston speed, m/sec
rpm(1,run) = eng_p(4);  %Engine RPM
R(1,run) = eng_p(5);    %Con rod / crank throw ratio

%Basic engine calculations and inputs

%Get number values for cycle inputs
for i = 1:length(input)
    if input(i,2) ~= 0
    input_num(i,1) = str2double(get(input(i,2),'String'));
    else
        input_num(i,1) = 0;
    end
end

input_f(:,run) = [displacement(1,run); rpm(1,run); m_p_speed(1,run); R(1,run);...
    input_num(:); option(:)];




if option(2) == 4
    nr = 1;                             %2 stroke
    input_f(8,run)=input_f(7,run);
elseif option(2) == 3 | option(2) == 1
    nr = 2;                             %4 stroke Standard/Miller
    input_f(8,run)=input_f(7,run);
elseif option(2) == 2
    nr = 2;                             %4 stroke Atkinson
   
end
        
    
V_dot = displacement(1,run)/nr*eng_p(4)/60;    %Volume displacement rate, m^3


I_p(1,run) = output_f(11,run)*V_dot;     %Indicated power, kW

vatm = 8.314/M*Tatm/Patm;   %Atmospheric specific volume, m^3/kg

if option 2 ~= 3
    %volumetric efficiency for everything but Miller Cycle
vol_eff(1,run) = (1-output_f(12,run))*vatm/(output_f(16,run)-output_f(19,run));  
else
vfinalm = output_f(16,run)/(1+.5*(rc-1)*(R(1,run)+1-cos(thetainit)-(R(1,run)^2-(sin(thetainit)).^2).^.5)); 
vol1_miller = vfinalm*(1+.5*(rc-1)*(R(1,run)+1-cos(-pi)-(R(1,run)^2-(sin(-pi)).^2).^.5));
vol_eff(1,run) = (1-output_f(12,run))*vatm/(vol1_miller-output_f(19,run));    
end

% vol_eff(1,run) = (1-output_f(12,run))*vatm/(output_f(16,run)*(rc-1)/rc);  %volumetric efficiency
if option(3) == 1
    m_dot_air(1,run) = V_dot*vol_eff(run)/vatm; %Air consumption rate
    m_dot_fuel(1,run) = 0;
    m_dot_fa(1,run) = m_dot_air(run);
elseif option(3) == 2
    %Premixed mixture
    m_dot_fa(1,run) = V_dot*vol_eff(run)/vatm*input_f(7,run)/input_f(8,run); %Fuel/Air consumption rate
    m_dot_fuel(1,run) = m_dot_fa(run)*fa/(1+fa); %Fuel consumption rate
    m_dot_air(1,run) = m_dot_fa(run) - m_dot_fuel(run);  %Air consumption rate
elseif option(3) == 3
    %Direct Injected mixture
    m_dot_air(1,run) = V_dot*vol_eff(run)/vatm*input_f(7,run)/input_f(8,run); %Air consumption rate
    m_dot_fuel(1,run) = m_dot_air(run)*fa;     %Fuel consumption rate
    m_dot_fa(1,run) = m_dot_fuel(run) + m_dot_air(run);  %Fuel/Air consumption rate
end

isfc(1,run) = m_dot_fuel(run)/I_p(run);

%Format output to send to excel

complete_output = [output_f(14:28,:); output_f(7:9,:);...
    output_f(11,:); vol_eff; I_p; isfc; m_dot_fuel; output_f(12:13,:);...
    input_f; P_ma; T_ma; v_ma; P_pa; v_pa];

xlswrite('cycle_output.xls',complete_output,'Raw_data','B5');
xlswrite('cycle_output.xls',X_f,'Composition','B5');


%Create pressure/specific volume and pressure/crank angle plots

P_vf = figure;
P_theta = figure;

for i = 1:run
    
if i == 1
    line1 = 'b-';
    line2 = 'b--';
elseif i == 2
    line1 = 'r-';
    line2 = 'r--';
elseif i == 3
    line1 = 'g-';
    line2 = 'g--';
elseif i == 4
    line1 = 'k-';
    line2 = 'k--';
elseif i == 5
    line1 = 'y-';
    line2 = 'y--';
elseif i == 6
    line1 = 'c-';
    line2 = 'c--';
end
figure(P_vf);    
    plot(v_ma(:,i),P_ma(:,i),line1,v_pa(:,i),P_pa(:,i),line2);
    legend(['Run ' num2str(i) ' Main loop'],['Run ' num2str(i) ' Pump loop']);
    legend1(2*i-1,:) = ['Run ' num2str(i) ' Main loop'];
    legend1(2*i,:) = ['Run ' num2str(i) ' Pump loop'];
    hold on;

figure(P_theta);
    plot([-360; 180/pi*theta_ma(:,i); 360],...
        [P_ma(1,i); P_ma(:,i); P_pa(length(P_pa),i)],line1);
    legend2(i,:) = ['Run ' num2str(i)];
    hold on;
end

figure(P_vf);
legend(legend1);
title('Pressure vs Specific Volume');
xlabel('Specific Volume (m^3)');
ylabel('Pressure (kPa)');

figure(P_theta)
legend(legend2);
title('Pressure vs Crank Angle');
xlabel('Crank Angle (degrees)');
ylabel('Pressure (kPa)');

msgbox('Calculations complete, see cycle_output.xls for calculation summary');
        
 


