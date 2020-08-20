function default_restore

%   Default restore function for Engine_sim
%
%   Callback for r_default_but in Engine_sim
%
%   KMF     April 27/05 Rev 1
%

global option defaults

option = csvread('default_opt_restore.txt');
defaults = csvread('defaults_restore.txt');

csvwrite('default_opt.txt',option);
csvwrite('defaults.txt',defaults);
msgbox('The next time the program is run the defaults will be restored');