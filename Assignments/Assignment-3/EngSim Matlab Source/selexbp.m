function selexbp

%   This function is run when the selection is changed in the exhaust back
%   pressure checkbox.  Depending on the selection the inputs in the main input
%   screen are changed
%   Callback for exhaust_b in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
%

global bgrnd exhaust_b input input_box defaults option

val = get(exhaust_b,'Value');

%Reset default values to new user entered values

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

for i = 1:3
if input(17,i) ~= 0
   delete(input(17,i));
end
end
input(17,:) = 0;


if val == 1
    option(5)=1;
input(17,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 410 80 20],...
    'String','P(exhaust)','HorizontalAlignment','Left','Parent',input_box);
input(17,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 414 50 20],...
    'String',defaults(17),'Parent',input_box);
input(17,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 410 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);
else
    option(5)=0;
end