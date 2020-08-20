%% ------------------------------------------------------------------------
% J.Naber
% Michigan Tech
% Date: 4/1/2013
%
% Parameters for General Release usage
%
% Initialization File For MTU_HVM_5_0a.mdl
% For MEEM/ECE 5295
%
%% ------------------------------------------------------------------------

%%
disp('- Loading Student Design Parameters...');

%% Vehicle Weight (Take this from the top of the Student_Design_Parameters.XXXXXXXX.xls file for Chief's Challenge)  
Vehicle_Mass_kg    = 1549;         % Vehicle mass, kg

%% Drive Train Options
% Trans Options (0,    1,    2,                           3 ) 
%               (5sp, 4sp, 4sp (alternative shift maps), 6sp)
Trans_Option       = 1;            % 
Motor_Gear_Ratio   = 1.00;         % Ratio of gear that connects the motor to the transmission output

%% ICE Options (0,1 2,3,4 or 5)
ICE_Option    = 5;                 % Optimized 2.4L

%% Battery Options (0,1 or 2)
Batt_Option  = 0;

%% Motor Options (0, 1 or 2)
Motor_Option = 0;

%% Tire Options
Vehicle_Tire_Coeff_Rolling_Resistance = 0.008;  % Coefficient of tire rolling resistance (-)

%% Aerodynamic Options
Vehicle_Drag_Coeff = 0.346;                     % Vehicle drag coefficient (-)

%% Electrical System Options
Batt_Aux_Load_W    = 800;                       % Auxillary electrical load in Watts

%%
disp('- Completed Loading Student Design Parameters ...');

disp(' - Loading ICE Technical Specifications ...');
ICE_Tech_Specs;

disp(' - Loading Battery Technical Specifications ...');
Batt_Tech_Specs;

disp(' - Loading Motor Technical Specifications ...');
Motor_Tech_Specs;

disp(' - Loading Transmission Technical Specifications ...');
Trans_Tech_Specs;

% -------------------------------------------------------------------------
% Additional from SPRING 2011 HW3 
% Computing for 2010 Malibu
% -------------------------------------------------------------------------

% Adjusted for 2010 Malibu with 4 speed transmission ...
h = 57.1 - 8.0;                       % (inches) Corrected height with ground clearance
w = 0.95*70.3;                        % (inches) Shape factor *  Width 
Vehicle_Frontal_Area_m                =    h*w*0.0254*0.0254;            % Frontal area of vehicle, m^2
Vehicle_Tire_Radius_m                 =    0.95*26.311/2*0.0254;         % Radius of tires, m (P215/55R17 93S) 
clear h w

%
% ICE5b + 4SP CostDown Baseline
%  Version 3.1a
%

if logical(1)
    TRANS_US_THRES = 1.0*TRANS_US_THRES;              
    TRANS_DS_THRES = 1.0*TRANS_DS_THRES;
    F2 = 0.4392;                                                               % Based upon GM paper SAE.2008-01-0458
    Vehicle_Drag_Coeff                    =    F2/(0.5*Air_Density_kgm*Vehicle_Frontal_Area_m);   %Cd = 0.3460
    clear F2
    Vehicle_Tire_Coeff_Rolling_Resistance =    0.008;                          % LRR tires Firestone  FR710
    Engine_BSFC_2DMAP_g_kWh               =    1.00*Engine_BSFC_2DMAP_g_kWh;   % Engine BSFC
end

% Paramater Sensitivity Analysis
%TRANS_US_THRES                        =    0.90 * TRANS_US_THRES;              
%TRANS_DS_THRES                        =    0.90 * TRANS_DS_THRES;
%Engine_ACC_Loss_Nm                    =    0.90 * Engine_ACC_Loss_Nm;
%Vehicle_Drag_Coeff                    =    0.90 * Vehicle_Drag_Coeff;
%Vehicle_Tire_Coeff_Rolling_Resistance =    0.90 * Vehicle_Tire_Coeff_Rolling_Resistance;
%Vehicle_Mass_kg                       =    0.90 * Vehicle_Mass_kg;               % Vehicle mass, kg
%Engine_BSFC_2DMAP_g_kWh               =    XXXX * Engine_BSFC_2DMAP_g_kWh;       % Engine BSFC
%Engine_Startup_Fuel_g                 =    0.00 * Engine_Startup_Fuel_g;

TRANS_Differential_Ratio   = 3.25;
