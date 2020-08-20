function selthrottle

%   This function is run when the selection is changed in the throttle
%   checkbox.  Depending on the selection the inputs in the main input
%   screen are changed
%   Callback for throttle in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
%

global bgrnd throttle option input input_box defaults
val = get(throttle,'Value');

%Reset default values to new user entered values

for i = 1:25
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

for i = 1:3
if input(7,i) ~= 0
   delete(input(7,i));
end
end
input(7,:) = 0;
if val == 1
    option(4)=1;
    input(7,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 235 80 20],...
    'String','P(manifold)','HorizontalAlignment','Left','Parent',input_box);
input(7,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 239 50 20],...
    'String',defaults(7),'Parent',input_box);
input(7,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 235 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);
     
else
    option(4)=0;
end