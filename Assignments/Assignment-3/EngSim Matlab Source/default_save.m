function default_save

%   Default save function for Engine_sim
%
%   Callback for default_but in Engine_sim
%
%   KMF     April 27/05 Rev 1
%

global option defaults input

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

csvwrite('default_opt.txt',option);
csvwrite('defaults.txt',defaults);