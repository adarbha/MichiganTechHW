function run_clear

%   This function will clear all previously calculated cycle runs.  If yes
%   is selected, the excel spreadsheet data will also be deleted.
%   Callback for clear button in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
% 


button = questdlg('Erase Excel cycle_output.xls data?');
global clear_run

val1 = strcmp(button,'Yes');
val2 = strcmp(button,'No');

if val1 == 1
clear_run = 1;

complete_output = zeros(626,12);
X_f = zeros(11,24);

xlswrite('cycle_output.xls',complete_output,'Raw_data','B5');
xlswrite('cycle_output.xls',X_f,'Composition','B5');

elseif val2 == 1
    
    clear_run = 1;
else
    clear_run = 0;
end
