function rev

%   This function is the callback for the rev button in cycle_assum.m  
%   Currently, all processes are isentropic, no reversibilities are available.
%
%   KMF     April 27/05 Rev 1
%


global option rev
option(9) = get(rev,'Value');
if option(9) ~= 1
    errordlg('This option is not available');
    set(rev,'Value',1);
end
