function seladdit(source,eventdata)

%   This function is run when the selection is changed in the additional
%   processes panel.  Depending on the selection the inputs in the main input
%   screen are changed
%   SelectionChangeFcn for addit panel in Engine_sim.m
%
%   KMF     April 27/05 Rev 1
%




global option defaults input bgrnd input_box

%Reset default values to new user entered values

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end


val = get(eventdata.NewValue,'String');
val1 = strcmp(val,'None');
val2 = strcmp(val,'Supercharging');
val3 = strcmp(val,'Turbocharging');
val4 = strcmp(val,'Turbocompounding');

for i = 18:22
    for j = 1:3
    if input(i,j) ~= 0
        delete(input(i,j));
    end
    end
end
input(18:22,:) = 0;

if val1 == 1
    option(6) = 1;
elseif val2 == 1
    option(6) = 2;
input(18,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 335 80 20],...
    'String','P(boost)','HorizontalAlignment','Left','Parent',input_box);
input(18,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 339 50 20],...
    'String',defaults(18),'Parent',input_box);
input(18,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 335 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);
input(19,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 310 80 20],...
    'String','Mech. Eff.','HorizontalAlignment','Left','Parent',input_box);
input(19,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 314 50 20],...
    'String',defaults(19),'Parent',input_box);
input(21,2)=uicontrol('Style','checkbox','String','Intercooler',...
'pos',[205 285 100 20],'HandleVisibility','off','Backgroundcolor',bgrnd,...
'Parent',input_box,'Callback','intercooler');

    
elseif val3 == 1
    option(6) = 3;
input(18,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 335 80 20],...
    'String','P(boost)','HorizontalAlignment','Left','Parent',input_box);
input(18,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 339 50 20],...
    'String',defaults(18),'Parent',input_box);
input(18,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 335 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);
input(19,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 310 80 20],...
    'String','Comp. Eff.','HorizontalAlignment','Left','Parent',input_box);
input(19,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 314 50 20],...
    'String',defaults(19),'Parent',input_box);
input(19,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 310 60 20],...
    'String','%','HorizontalAlignment','Left','Parent',input_box);
input(20,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 285 80 20],...
    'String','Turb. Eff.','HorizontalAlignment','Left','Parent',input_box);
input(20,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 289 50 20],...
    'String',defaults(20),'Parent',input_box);
input(20,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 285 60 20],...
    'String','%','HorizontalAlignment','Left','Parent',input_box);
input(21,2)=uicontrol('Style','checkbox','String','Intercooler',...
'pos',[205 260 100 20],'HandleVisibility','off','Backgroundcolor',bgrnd,...
'Parent',input_box,'Callback','intercooler');


elseif val4 == 1
    option(6) = 4;
input(18,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 335 80 20],...
    'String','dP(turbine)','HorizontalAlignment','Left','Parent',input_box);
input(18,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 339 50 20],...
    'String',defaults(18),'Parent',input_box);
input(18,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 335 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box);
input(19,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[205 310 80 20],...
    'String','Mech. Eff.','HorizontalAlignment','Left','Parent',input_box);
input(19,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[285 314 50 20],...
    'String',defaults(19),'Parent',input_box);
input(19,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[340 310 60 20],...
    'String','%','HorizontalAlignment','Left','Parent',input_box);
end

