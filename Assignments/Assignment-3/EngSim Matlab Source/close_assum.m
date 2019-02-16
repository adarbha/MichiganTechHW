function close_assum

%   Callback for close button in Cycle Assumptions figure.  
%
%   Adjusts options to reflect choices made in the Cycle Assumptions window
%   and adjusts inputs on the main input window accordingly.  
%
%   KMF     April 27/05 Rev 1
%

global bgrnd cycle_fig option input input_box defaults
global mix_option ht rev m_losses
global species_data species_thdata
get(ht,'Value');
option(7) = get(mix_option,'Value');
option(8) = get(ht,'Value');
option(9) = get(rev,'Value');
option(10) = get(m_losses,'Value');

%Reset default values to new user entered values

for i = 1:30
    if input(i,2) ~= 0
        defaults(i) = str2double(get(input(i,2),'String'));
    end
end

%Clear gui screen and graphics handles

for i = 8:15
    for j = 1:3
        if input(i,j) ~= 0
            delete(input(i,j));
        end
    end
    input(i,:)=0;
end

%Air Standard inputs

if option(3) == 1 & option(7) == 1
    
%Cp input
input(8,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 185 80 20],...
    'String','Cp','HorizontalAlignment','Left','Parent',input_box);
input(8,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 189 50 20],...
    'String',defaults(8),'Parent',input_box);
input(8,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 185 40 20],...
    'String','kJ/kg°K','HorizontalAlignment','Left','Parent',input_box);      

%Cv input
input(9,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 160 80 20],...
    'String','Cv','HorizontalAlignment','Left','Parent',input_box);
input(9,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 164 50 20],...
    'String',defaults(9),'Parent',input_box);
input(9,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 160 40 20],...
    'String','kJ/kg°K','HorizontalAlignment','Left','Parent',input_box);

%qin input
input(10,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 135 80 20],...
    'String','qin','HorizontalAlignment','Left','Parent',input_box);
input(10,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 139 50 20],...
    'String',defaults(10),'Parent',input_box);
input(10,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 135 40 20],...
    'String','kJ/kg','HorizontalAlignment','Left','Parent',input_box);
    
%Real air inputs    
    species_data = 0;
    species_thdata = 0;
    
    elseif option(3) == 1 & option(7) == 2
        
%qin input
input(10,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 185 80 20],...
    'String','qin','HorizontalAlignment','Left','Parent',input_box);
input(10,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 189 50 20],...
    'String',defaults(10),'Parent',input_box);
input(10,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 185 60 20],...
    'String','kJ/kg','HorizontalAlignment','Left','Parent',input_box);
    species_data = 0;
    species_thdata = 0;

elseif option(3) == 2
input(8,1)=uicontrol('Style','pushbutton','String','Fuel Composition','pos',...
         [33 190 120 20],'Callback','Reactant_Species','BackgroundColor',bgrnd,...
         'Parent',input_box);
input(11,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 160 80 20],...
    'String','Eq. ratio','HorizontalAlignment','Left','Parent',input_box);
input(11,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 164 50 20],...
    'String',defaults(11),'Parent',input_box);

    
elseif option(3) == 3
input(8,1)=uicontrol('Style','pushbutton','String','Fuel Composition','pos',...
         [33 190 120 20],'Callback','Reactant_Species','BackgroundColor',bgrnd,...
         'Parent',input_box);
input(11,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 160 80 20],...
    'String','Eq. Ratio','HorizontalAlignment','Left','Parent',input_box);
input(11,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 164 50 20],...
    'String',defaults(11),'Parent',input_box);
input(12,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 135 80 20],...
    'String','Cp fuel','HorizontalAlignment','Left','Parent',input_box);
input(12,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 139 50 20],...
    'String',defaults(12),'Parent',input_box);
input(12,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 135 60 20],...
    'String','kJ/kg°K','HorizontalAlignment','Left','Parent',input_box);  
input(13,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 110 80 20],...
    'String','h°f fuel','HorizontalAlignment','Left','Parent',input_box);
input(13,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 114 50 20],...
    'String',defaults(13),'Parent',input_box);
input(13,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 110 60 20],...
    'String','kJ/kmol','HorizontalAlignment','Left','Parent',input_box); 
input(14,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 85 80 20],...
    'String','Fuel density','HorizontalAlignment','Left','Parent',input_box);
input(14,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 89 50 20],...
    'String',defaults(14),'Parent',input_box);
input(14,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 85 60 20],...
    'String','kg/m^3','HorizontalAlignment','Left','Parent',input_box);  
input(15,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 60 80 20],...
    'String','Pinject','HorizontalAlignment','Left','Parent',input_box);
input(15,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 64 50 20],...
    'String',defaults(15),'Parent',input_box);
input(15,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 60 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box); 
end




close(cycle_fig)