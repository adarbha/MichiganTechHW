function heat_trans


%   This function is the callback for the ht button in cycle_assum.m  
%   Currently, all processes are adiabatic, no heat loss is available.
%
%   KMF     April 27/05 Rev 1
%


global option ht
option(8) = get(ht,'Value');
if option(8) ~= 1
    errordlg('This option is not available');
    set(ht,'Value',1);
end
