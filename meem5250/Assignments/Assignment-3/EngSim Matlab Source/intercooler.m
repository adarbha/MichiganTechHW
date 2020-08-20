function intercooler

%   This function is the callback for the checkbox defined in input(21,2).
%   It is used to determine if intercooling will be used for supercharged
%   or turbocharged cycles.  
%
%   KMF     April 27/05 Rev 1
%


global input option input_box bgrnd defaults
 

%Reset default values to new user entered values

for i = 22
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end


for i = 22
    for j = 1:3
        if input(i,j) ~= 0
            delete(input(i,j));
        end
    end
    input(i,:)=0;
end

intercool = get(input(21,2),'Value');

if intercool == 1
if option(6) == 3
    y = 235;
else
    y = 260;
end
input(22,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 y 80 20],...
    'String','Exit Temp','HorizontalAlignment','Left','Parent',input_box);
input(22,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 y+4 50 20],...
    'String',defaults(22),'Parent',input_box);
input(22,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 y 60 20],...
    'String','°K','HorizontalAlignment','Left','Parent',input_box);
end