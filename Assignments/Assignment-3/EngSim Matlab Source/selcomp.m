function selcomp(source,eventdata)

%   This function is run when the selection is changed in the compression/
%   expansion processes panel.  Depending on the selection the inputs 
%   in the main input screen are changed.
%   SelectionChangeFcn for comp panel in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
%

global bgrnd option input input_box defaults

%Reset default values to new user entered values

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

val = get(eventdata.NewValue,'String');
val1 = strcmp(val,'4 Stroke Standard');
val2 = strcmp(val,'Atkinson');
val3 = strcmp(val,'Miller');
val4 = strcmp(val,'2 Stroke Standard');

for i = 4:5
    for j = 1:3
    if input(i,j) ~= 0
        delete(input(i,j));
    end
    end
end
input(4:5,:) = 0;


if val1 == 1    %Four stroke standard cycle
    option(2) = 1;
    
elseif val2 == 1    %Atkinson cycle
    option(2) = 2;
    
%Expansion ratio input    
input(4,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 310 80 20],...
    'String','Exp. Ratio','HorizontalAlignment','Left','Parent',input_box);
input(4,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 314 50 20],...
    'String',defaults(4),'Parent',input_box);

elseif val3 == 1    %Miller cycle
    option(2) = 3;

%IVC crank angle input
input(5,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 310 80 20],...
    'String','IVC angle','HorizontalAlignment','Left','Parent',input_box);
input(5,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 314 50 20],...
    'String',defaults(5),'Parent',input_box);
input(5,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 310 60 20],...
    'String','degrees','HorizontalAlignment','Left','Parent',input_box);

elseif val4 == 1    %Two stroke standard cycle
    option(2) = 4;
end

