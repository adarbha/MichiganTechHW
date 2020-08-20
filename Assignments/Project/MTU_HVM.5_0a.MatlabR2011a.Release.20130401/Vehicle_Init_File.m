%% ------------------------------------------------------------------------  
% J.Naber
% Michigan Tech
% Date: 2013-04-01
%
% Initialization File For MTU_HVM_5_0a.mdl
%
% Added variable Engine_Displacement_L for scaling.
%
%
%% ------------------------------------------------------------------------
clear all
close all;
clc;

%%
%------------------------------Load Parameters-----------------------------
choice = menu('Select Test Condition', ...
              'Constant Speed Points: 0, 10, .... 80 90 80 ... mph ',...  
              'Performance Test', ...
              'UDDS Cycle',  ...
              'HWFET Cycle', ...
              'US06 Cycle',  ...
              'ECE-15 Cycle', ...
              'EUDC Cycle', ...
              'GENERIC Cycle');                           %Prompt user
if choice==1
    load('Constant_Speed_Points_Cycle.mat');
elseif choice ==2
    load('Performance_Test');
elseif choice==3
    load('UDDS_Cycle.mat');
elseif choice==4    
    load('HWFET_Cycle.mat');
elseif choice==5
    load('US06_Cycle.mat');
elseif choice==6
    load('ECE_15_Cycle.mat');
elseif choice==7
    load('EUDC_Cycle.mat');
elseif choice==8
    load('GENERIC_Cycle.mat');
end

% Plot Test cycle
figure; 
    set(gcf, 'position', [50 50 900 600]);
    h = plot(TEST_CYCLE(:,1), TEST_CYCLE(:,2), 'r');
        set(h, 'linewidth', 2);
        set(gca, 'fontsize', 16, 'fontname', 'Calibri');
        xlabel('Time (sec)');
        ylabel('Vehicle Speed (mph)');
        grid on;
    
%-------------------------Fuel and Energy Constants------------------------
Fuel_Density_kgm3 = 742;               %Density of gasoline, kg/m^3
Fuel_LHV_MJkg     = 43.42;             %Lower heating value of gasoline, MJ/kg          

%---------------------------------Base IC Engine (2.1L Inline 4 Cyl) ----------------------------------
% 
Engine_Min_Speed_rpm    =  800; %Max engine speed, rpm
Engine_Max_Speed_rpm    = 6000; %Max engine speed, rpm
Engine_Startup_Fuel_g   =   10; %Fuel, grams	

Engine_2DMAP_Index_TR   = [0.08, 0.16, 0.24, 0.32, 0.40, 0.48, 0.56, 0.64, 0.72, 0.80, 0.88, 0.96, 1.00];
Engine_2DMAP_Index_RPM  = [800,  1200, 1600, 2000, 2400, 2800, 3200, 3600, 4000, 4800, 6000];

%% Scaled to 3.6L
Engine_Displacement_L   =    3.6;                             % Liters
Engine_ACC_Loss_Nm      =   17.1; %Accessory loss, N-m


Engine_Torque_2DMAP_Nm =[     17    14    10     7    31    27    26    26    17     9     3;
                              46    41    36    34    60    57    55    77    45    36    22;
                              72    67    65    63    87    84    82   106    74    63    50;
                              98    94    93    91   115   113   111   134   101    91    77;
                             122   122   120   118   142   141   139   161   127   118   103;
                             147   147   146   146   170   168   166   189   154   146   130;
                             171   175   173   173   180   195   194   214   182   171   156;
                             195   201   201   201   197   223   221   231   209   199   182;
                             219   226   228   228   225   250   249   254   237   225   206;
                             243   252   254   255   252   279   276   274   264   252   231;
                             266   278   281   283   279   305   303   297   290   278   257;
                             273   303   307   309   307   333   329   322   317   305   283;
                             273   310   331   333   334   353   350   350   345   331   305;];
Engine_Torque_2DMAP_Nm = Engine_Torque_2DMAP_Nm';

Engine_BSFC_2DMAP_g_kWh = [ 855         869        1167        1591         549         628         707         991        1240        3058        9624;
                            452         469         486         499         385         413         450         427         644         986        2248;
                            388         379         371         368         329         346         372         378         499         707        1311;
                            358         337         327         319         300         313         334         349         437         596        1029;
                            342         316         302         293         283         293         313         332         402         538         892;
                            331         302         287         278         271         280         299         319         378         503         814;
                            324         294         277         267         267         270         288         310         362         480         765;
                            321         287         270         260         262         264         281         294         349         460         728;
                            316         282         265         254         255         259         275         290         342         447         703;
                            315         279         261         250         251         276         291         306         342         437         684;
                            324         298         281         271         268         297         313         335         370         463         669;
                            331         325         304         294         291         319         338         365         400         498         720;
                            331         332         327         313         314         338         355         396         428         533         765;];
                        
Engine_BSFC_2DMAP_g_kWh = Engine_BSFC_2DMAP_g_kWh';                 

% Plot data.
if logical(0)
    T = Engine_Torque_2DMAP_Nm;
    N = Engine_2DMAP_Index_RPM;
    N = N'*ones(1,size(T,2));
    figure;
        subplot(1,2,1);
            contourf(N,T, Engine_Torque_2DMAP_Nm,  [0:25:200]);
        subplot(1,2,2);
            contourf(N,T, Engine_BSFC_2DMAP_g_kWh, [225:25:800]);
    clear T N
end
        
%-------------------------------Transmission-------------------------------
% Baseline 5, Malibu 4 speed, Malibu 6 speed) 
% Option   0        1               2
Trans_Option = 1;

%--------------------------Mechanical Drivetrain---------------------------
Motor_Gear_Ratio   = 0.33;           % Ratio of gear that connects the motor to the transmission output                                    

%---------------------------------Electric Motor---------------------------
Motor_Mass = 41;                     % Motor Mass, kg
Motor_Km   = 1.08;                   % Motor Torque constant, N-m/A
Motor_Ra   = 0.135;                  % Armature resistance, ohms

%---------------------------------Battery----------------------------------
Batt_Initial_SOC             = 0.8;      % Initial Battery SOC
Batt_Capacity_Ah             = 5.0;      % Battery rating from name plate, Ah
Batt_Const_V                 = 100;      % Battery constant voltage, V
Batt_Upper_Volt_Limit_V      = 142.9;    % Battery upper voltage limit, V
Batt_Lower_Volt_Limit_V      = 62.8;     % Battery lower voltage limit, V
Batt_Max_Charge_Current_A    = 75;       % Battery max charging current, A
Batt_Max_Discharge_Current_A = -75;      % Battery max discharging current, A
Batt_Max_SOC                 = 0.9;      % Maximum limit for SOC charging
Batt_Min_SOC                 = 0.5;      % Minimum limit for SOC charging
Batt_dG                      = -371100;  % Free energy difference between discharged & charged electrodes
Batt_OCV_Z                   = 2;        % Battery OCV Z
Batt_a                       = 4;        % Molecular interaction exponent
Batt_Resis_Ohms              = 0.5;      % Battery Resistance, Ohms
Batt_Warburg_Resis_Ohms      = 0.25;     % Warburg Resistance, Ohms
Batt_Warburg_Capcitance_F    = 15;       % Warburg Capacitance, F
Batt_Numb_Cells_N            = 51;       % Number of cell in battery pack
Batt_Aux_Load_W              = 1000;     % Auxillary electrical load, W
Batt_Disable_SOC             = 0.05;      % SOC limit to disable battery

%----------------------------Vehicle Parameters----------------------------
Vehicle_Mass_kg = 1713;                             % Vehicle mass, kg
Vehicle_Frontal_Area_m = 2.686;                     % Frontal area of vehicle, m^2
Vehicle_Drag_Coeff = 0.417;                         % Vehicle drag coefficient
Vehicle_Tire_Radius_m = 11*0.0254;                  % Radius of tires, m
Vehicle_Tire_Coeff_Rolling_Resistance=0.018;        % Coefficient of tire rolling resistance
Vehicle_Tire_Static_Fric_Coeff = 0.8;               % Coefficient of static friction 0.4<Static_Fric_Coeff<0.8 (modified from 1.06e)
Vehicle_Tire_Rolling_Fric_Velocity_Modifier = 44.7; % Modifying factor if vehicle velocity in m/s
Max_Vehicle_Speed_Control_Error_mph = 2;            % Maximum allowable +/- error tolerence
CG_Ratio = 0.6;                                     % Ratio of weight distribution between front and rear wheels
                                                    % Need to change model to drive from front wheels.  

%------------------------------Parasitic Parameters-----------------------------
Gravity         = 9.81;             % Accelearion due to gravity, m/s^2
Air_Density_kgm = 1.2;              % Air density, kg/m^3


%% Load Student Parameters into the initilization variables.
disp('- Loading Student Design Parameters ...');
Student_Design_Parameters

%% Complete Computations of data.
Vehicle_Tractive_Force_Limit=(Vehicle_Mass_kg*Gravity)*Vehicle_Tire_Static_Fric_Coeff*CG_Ratio; %Tractive force limit set by road friction, N

