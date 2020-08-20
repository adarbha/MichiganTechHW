%% Define Transmission Parameters
%
% Jeff Naber
% Michigan Tech
% March 4th, 2011
%
% Initialization File For MTU_HVM_3_1a.mdl
%
%

%%
%%
s = sprintf ('   - Setting Transmission Option Parameters:  Trans_Option = %2d', Trans_Option);
disp(s);


%% ------------------------------------------------------------------------
% Updated 2011.03.05 to six speed and options for 0, 1, 2
% Relabeled to TRANS_Gear_Ratio

TRANS_GEAR_INDEX   = [0, 1, 2, 3, 4, 5];            % Gear number (0-5) = physical gears (1-6) [#]

TRANS_TORQUE_INDEX = [0.1, 0.3, 0.5, 0.7, 0.9];     % Normalized Engine Torque Request (0-1) [-]

TRANS_Gear_Selection    = 1;                        % Starts the trans in gear one
    
% These are predefined in Vehicle_Init_File as defaults. Changed here for options.  
% Baseline 5 speed From Version 1.06e
if (Trans_Option == 0) 

    TRANS_Differential_Ratio = 2.73;      % Ratio of the rear differential

    TRANS_Gear_Ratio(1)    = 3.06;    
    TRANS_Gear_Ratio(2)    = 1.63;
    TRANS_Gear_Ratio(3)    = 1.00;
    TRANS_Gear_Ratio(4)    = 0.70;
    TRANS_Gear_Ratio(5)    = 0.60;
    TRANS_Gear_Ratio(6)    = 0.60;       % Repeat for 5 speed



    % Transmission shift thresholds (mph)
    TRANS_US_THRES =   [    10    12    15    20    25
                            20    22    25    30    35
                            30    32    35    40    45
                            40    42    45    50    55
                           300   300   300   300   300
                           300   300   300   300   300  ];
                           
    TRANS_DS_THRES =    [    0     0     0     0     0
                             5     7    10    15    20
                            15    17    20    25    30
                            25    27    30    35    40
                            40    42    45    50    60  
                            40    42    45    50    60]; (mph)

% - 2010 Chevy Malibu 4 speed automatic transmission with 3.91 final drive
%   Original Shift Maps
elseif (Trans_Option == 1) 

    TRANS_Differential_Ratio = 3.91;         % Ratio of the rear differential (final drive ratio)

    TRANS_Gear_Ratio(1)    = 2.95;
    TRANS_Gear_Ratio(2)    = 1.62;
    TRANS_Gear_Ratio(3)    = 1.00;
    TRANS_Gear_Ratio(4)    = 0.68;
    TRANS_Gear_Ratio(5)    = 0.68;   % Four speed so model as repeated gear.
    TRANS_Gear_Ratio(6)    = 0.68;
                            
    % Transmission shift thresholds (mph)
    TRANS_US_THRES =   [10	 12	 18	 25	 40
                        20	 22	 32	 45	 65
                        30	 32	 42	 70	100
                        42	 44	 65	110	150
                       300  300	300 300	300                        
                       300	300	300	300	300];   %(mph)

    TRANS_DS_THRES =   [ 0   0   0   0   0
                         5	 7	11	18	31
                        15	17	25	35	52
                        25	27	37	55	82
                        35	37	50	85	125
                         1   1   1   1   1];   %(mph)                            
        
                            
% - 2010 Chevy Malibu 4 speed automatic transmission with 3.91 final drive
%   Revised Shift maps 20110314
elseif (Trans_Option == 2) 

    TRANS_Differential_Ratio = 3.91;         % Ratio of the rear differential (final drive ratio)

    TRANS_Gear_Ratio(1)    = 2.95;
    TRANS_Gear_Ratio(2)    = 1.62;
    TRANS_Gear_Ratio(3)    = 1.00;
    TRANS_Gear_Ratio(4)    = 0.68;
    TRANS_Gear_Ratio(5)    = 0.68;   % Four speed so model as repeated gear.
    TRANS_Gear_Ratio(6)    = 0.68;
    
%                
%    TRANS_US_THRES =   [12	 13.8	21.0  29.0	 41.3
%                        22	 25.5	39.0  52.8	 75.1
%                        36	 41.5	65.0  85.6	121.7
%                      300   300    300	  300	300
%                       300   300	300	  300	300
%                      300	 300	300	  300	300   ];   %(mph)
    TRANS_US_THRES =   [11.5	15.0	19.1	29.0	41.3
                        21.5	27.5	36.0	52.8	75.1
                        35.5	45.5	59.1	85.6	121.7
                        300     300     300     300     300
                        300     300     300     300     300
                        300     300     300     300     300   ];   %(mph)


%sprintf('\t\t\t%5.0f\t%5.0f\t%5.0f\t%5.0f\t%5.0f\n',  ICE_SPD_US') 
%sprintf('\t\t\t%5.0f\t%5.0f\t%5.0f\t%5.0f\t%5.0f\n',  ICE_SPD_US_AS') 

                   
    TRANS_DS_THRES =   [ 0    0    0     0       0;
                         8	11.5  15.5  20.4	35.0
                        15	20.9  29.4  37.2	58.7
                        25	33.9  48.5  60.2	95.0
                        1	 1	   1     1       1   %% Downshift if your in 5th out of 4.
                        1	 1	   1     1       1  ];   %(mph)

%sprintf('\t\t\t%5.0f\t%5.0f\t%5.0f\t%5.0f\t%5.0f\n',  ICE_SPD_DS') 
%sprintf('\t\t\t%5.0f\t%5.0f\t%5.0f\t%5.0f\t%5.0f\n',  ICE_SPD_DS_AS') 


% - 2010 Chevy Malibu 6 speed automatic transmission with 2.77 final drive
elseif (Trans_Option == 3) 

    TRANS_Differential_Ratio = 2.77;         % Ratio of the rear differential (final drive ratio)

    TRANS_Gear_Ratio(1)     = 4.58;
    TRANS_Gear_Ratio(2)     = 2.96;
    TRANS_Gear_Ratio(3)     = 1.91;
    TRANS_Gear_Ratio(4)     = 1.45;
    TRANS_Gear_Ratio(5)     = 1.00;   
    TRANS_Gear_Ratio(6)     = 0.75;
    
    % Transmission shift thresholds (mph)
    TRANS_US_THRES =   [10	 12	 18	 25	 40
                        20	 22	 32	 45	 65
                        30	 32	 42	 70	100
                        42	 44	 65	110	150
                        52	 55  75 120	180
                       300	300	300	300	300];   %(mph)
                   
                       

                       
                       

    TRANS_DS_THRES =   [ 0   0   0   0   0
                         5	 7	11	18	31
                        15	17	25	35	52
                        25	27	37	55	82
                        35	37	50	85	125
                        35	37	50	85	125];   %(mph)
end       
                
%% Plot Shift points
if logical(0)
  fs = 16;
  figure;
  set(gcf, 'position', [150 150 650 500])
    h = plot(TRANS_TORQUE_INDEX, TRANS_US_THRES(1:3,:)', 'rs-');
      set(h, 'markerfacecolor', [0.8 0 0.0], 'color', [0.6 0.0 0], 'markersize', 8);
      hold on;
    h = plot(TRANS_TORQUE_INDEX, TRANS_DS_THRES(2:4,:)', 'gd-');
      set(h, 'markerfacecolor', [0 0.7 0], 'color', [0 0.4 0], 'markersize', 8);
      axis([0 1 0 120]);
      set(gca, 'fontsize', fs, 'fontname', 'Calibri');
      grid on;
      xlabel('Normalized Engine Torque [-]');
      ylabel('Shift Treshold [mph]');
%      legend('US Threshold', ...
%             'DS Threshold', 2);
    clear fs h
end

