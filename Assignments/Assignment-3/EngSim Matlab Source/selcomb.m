function selcomb(source,eventdata)

%   This function is run when the selection is changed in the combustion
%   processes panel.  Depending on the selection the inputs in the main input
%   screen are changed.
%   SelectionChangeFcn for comb panel in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
%


global bgrnd option input input_box defaults mix

%Reset default values to new user entered values

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

val = get(eventdata.NewValue,'String');
val1 = strcmp(val,'Otto (Constant Volume)');
val2 = strcmp(val,'Diesel (Constant Pressure)');
val3 = strcmp(val,'Limited Pressure');
val4 = strcmp(val,'Arbitrary Heat Release');

for i = 1:3
    if input(16,i) ~= 0
        delete(input(16,i));
    end
    for j = 25:30
        if input(j,i) ~=0
            delete(input(j,i));
        end
    end
end
input(16,:) = 0;
input(25:30,:) = 0;

if val1 == 1
    option(1) = 1;
elseif val2 == 1
    option(1) = 2;
elseif val3 == 1
    option(1) = 3;

%Limited Pressure input
    
input(16,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[185 185 80 20],...
    'String','Max Pressure','HorizontalAlignment','Left','Parent',input_box);
input(16,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[265 189 50 20],...
    'String',defaults(16),'Parent',input_box);
input(16,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[320 185 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);

elseif val4 == 1
    option(1) = 4;
    
input(25,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[185 185 80 20],...
    'String','Ignition','HorizontalAlignment','Left','Parent',input_box);
input(25,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[265 189 50 20],...
    'String',defaults(25),'Parent',input_box);
input(25,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[320 185 60 20],...
    'String','°','HorizontalAlignment','Left','Parent',input_box);    
    
input(26,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[185 160 80 20],...
    'String','Burn Duration','HorizontalAlignment','Left','Parent',input_box);
input(26,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[265 164 50 20],...
    'String',defaults(26),'Parent',input_box);
input(26,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[320 160 60 20],...
    'String','°','HorizontalAlignment','Left','Parent',input_box);    
input(27,1)=uicontrol('Style','pushbutton','backgroundcolor',bgrnd,'pos',[185 135 130 20],...
    'String','Knock Simulation','HorizontalAlignment','Center','Parent',input_box,...
    'Callback','knock_sim');
msgbox('Mixture must be Air Standard only - Standard Compression/Expansion Processes Only');
    option(7) = 1;
    
end

