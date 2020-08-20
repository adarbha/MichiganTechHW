%% Battery Technical Specifications
% Michigan Tech
% April 7th, 2010
%
% Initialization File For MTU_HVM_2_0e.mdl
%
%
% Batt_Option is selected in "Student_Design_Parameters.m"


disp('   - Setting Battery Option Parameters');

if (Batt_Option == 0)     %% Lead Acid
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
    
elseif (Batt_Option==1)   %% Nickel Metal Hydride
    % Option 1
    Batt_Initial_SOC=0.8;                    % Initial Battery SOC
    Batt_Capacity_Ah             = 5.0;      % Battery rating from name plate, Ah
    Batt_Const_V                 = 300;      % Battery constant voltage, V
    Batt_Upper_Volt_Limit_V      = 369.4;    % Battery upper voltage limit, V
    Batt_Lower_Volt_Limit_V      = 228.4;    % Battery lower voltage limit, V
    Batt_Max_Charge_Current_A    = 80;       % Battery max charging current, A
    Batt_Max_Discharge_Current_A = -80;      % Battery max discharging current, A
    Batt_Max_SOC                 = 0.9;      % Maximum limit for SOC charging
    Batt_Min_SOC                 = 0.4;      % Minimum limit for SOC charging
    Batt_dG                      = -115000;  % Free energy difference between discharged & charged electrodes
    Batt_OCV_Z                   = 1;        % Battery OCV Z
    Batt_a                       = 0.8;      % Molecular interaction exponent
    Batt_Resis_Ohms              = 0.8;      % Battery Resistance, Ohms
    Batt_Warburg_Resis_Ohms      = 0.4;      % Warburg Resistance, Ohms
    Batt_Warburg_Capcitance_F    = 12.5;     % Warburg Capacitance, F
    Batt_Numb_Cells_N            = 246;      % Number of cell in battery pack
    
elseif (Batt_Option==2)   %% Li-Ion
    % Option 2
    Batt_Initial_SOC=0.8;                    % Initial Battery SOC
    Batt_Capacity_Ah             = 13.0;     % Battery rating from name plate, Ah
    Batt_Const_V                 = 300;      % Battery constant voltage, V
    Batt_Upper_Volt_Limit_V      = 371.5;    % Battery upper voltage limit, V
    Batt_Lower_Volt_Limit_V      = 228.1;    % Battery lower voltage limit, V
    Batt_Max_Charge_Current_A    = 167;      % Battery max charging current, A
    Batt_Max_Discharge_Current_A = -167;     % Battery max discharging current, A
    Batt_Max_SOC                 = 0.9;      % Maximum limit for SOC charging
    Batt_Min_SOC                 = 0.3;      % Minimum limit for SOC charging
    Batt_dG                      = -355000;  % Free energy difference between discharged & charged electrodes
    Batt_a                       = 4;        % Molecular interaction exponent
    Batt_OCV_Z                   = 1;        % Battery OCV Z parameter
    Batt_Resis_Ohms              = 0.8;      % Battery Resistance, Ohms
    Batt_Warburg_Resis_Ohms      = 0.4;      % Warburg Resistance, Ohms
    Batt_Warburg_Capcitance_F    = 125;      % Warburg Capacitance, F
    Batt_Numb_Cells_N            = 79;       % Number of cell in battery pack
end