function mass

%   This function is the callback for the m_losses button in cycle_assum.m  
%   Currently, no mass losses are calculated, so this option is
%   unavailable.
%
%   KMF     April 27/05 Rev 1
%

global option m_losses
option(10) = get(m_losses,'Value');
if option(10) ~= 1
    errordlg('This option is not available');
    set(m_losses,'Value',1);
end
