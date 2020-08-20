function Engine_sim

%   Main Engine Cycle Simulator program component
%
%   KMF     April 27/05 Rev 1
%
%   JBB     Sept 24/09  Remove "defaultdir.txt" file and use current
%                       working directory instead to find species file.

h = waitbar(0,'Loading Engine Cycle Simulator');
        for i=1:500

            % computation here %
            waitbar(i/100,h)
        end
        close(h)


% Initialize default variables required for this program

global bgrnd txtcolor option defaults rtd_pathfile mol_frac_return mix
global throttle exhaust_b input input_box p_v P v eng_sim eng_p
P = [0 0];
v = [0 1];

% Determine current working directory and adjust to address species file
rtd_pathfile = [pwd,'\comb3.xls'];

mol_frac = zeros(50,1);

bgrnd=[ 0.90 0.90 0.90 ];
txtcolor = [.73 .9 .9];
option = csvread('default_opt.txt');
defaults = csvread('defaults.txt');
mol_frac_return = csvread('default_fuel.txt');
eng_sim = figure;
input = zeros(30,3);
eng_p = defaults(31:35);
%Get the screen resolution

size = get(0,'Screensize');
width = size(3);
height = size(4);

%Set window parameters

set(gcf,'numbertitle','off','name','Engine Cycle Simulator');
   set(gcf,'outerposition',[1 1 width height],'color',bgrnd,'Resize','off');
   
%Initialize pressure-volume plot axes
   
p_v=axes('Units','pixels','Position',[75 height - 675 375 425],...
   'XTickLabelMode','manual','YTickLabelMode','manual');
   title('Pressure - Volume');
   xlabel('Specific Volume');
   ylabel('Pressure');
   
%Initialize pressure-crank angle axes   
%{   
p_theta=axes('Units','pixels','Position',[50 75 700 200],...
   'XTickLabelMode','manual','YTickLabelMode','manual');
   title('Pressure - Crank Angle');
   xlabel('Crank Angle');
   ylabel('Pressure');
%}   
%Combustion process button group
   
comb = uibuttongroup('visible','off','Units','pixels',...
     'pos',[5 height - 190 160 100],'Backgroundcolor',bgrnd);
otto = uicontrol('Style','Radio','String','Otto (Constant Volume)',...
    'pos',[5 65 150 20],'parent',comb,'HandleVisibility','off','Backgroundcolor',bgrnd);
diesel = uicontrol('Style','Radio','String','Diesel (Constant Pressure)',...
    'pos',[5 45 150 20],'parent',comb,'HandleVisibility','off','Backgroundcolor',bgrnd);
l_p = uicontrol('Style','Radio','String','Limited Pressure',...
    'pos',[5 25 150 20],'parent',comb,'HandleVisibility','off','Backgroundcolor',bgrnd);
finite = uicontrol('Style','Radio','String','Arbitrary Heat Release',...
    'pos',[5 5 150 20],'parent',comb,'HandleVisibility','off','Backgroundcolor',bgrnd);
set(comb,'SelectionChangeFcn',@selcomb);
set(comb,'SelectedObject',[]);  % No selection
set(comb,'Visible','on','Title','Combustion Process'); 

%Compression/Expansion button group

comp = uibuttongroup('visible','off','Units','pixels',...
     'pos',[170 height - 190 150 100],'Backgroundcolor',bgrnd);
stand = uicontrol('Style','Radio','String','4 Stroke Standard',...
    'pos',[5 65 140 20],'parent',comp,'HandleVisibility','off','Backgroundcolor',bgrnd);
atkin = uicontrol('Style','Radio','String','Atkinson',...
    'pos',[5 45 140 20],'parent',comp,'HandleVisibility','off','Backgroundcolor',bgrnd);
miller = uicontrol('Style','Radio','String','Miller',...
    'pos',[5 25 140 20],'parent',comp,'HandleVisibility','off','Backgroundcolor',bgrnd);
two_stroke = uicontrol('Style','Radio','String','2 Stroke Standard',...
    'pos',[5 5 140 20],'parent',comp,'HandleVisibility','off','Backgroundcolor',bgrnd);
set(comp,'SelectionChangeFcn',@selcomp);
set(comp,'SelectedObject',[]);  % No selection
set(comp,'Visible','on','Title','Compression/Expansion');

%Mixture preparation button group

mix = uibuttongroup('visible','off','Units','pixels',...
     'pos',[325 height - 190 150 100],'Backgroundcolor',bgrnd);
air = uicontrol('Style','Radio','String','Air Only',...
    'pos',[5 65 140 20],'parent',mix,'HandleVisibility','off','Backgroundcolor',bgrnd);
pre_mix = uicontrol('Style','Radio','String','Pre-mixed',...
    'pos',[5 45 140 20],'parent',mix,'HandleVisibility','off','Backgroundcolor',bgrnd);
direct_inj = uicontrol('Style','Radio','String','Direct Injection',...
    'pos',[5 25 140 20],'parent',mix,'HandleVisibility','off','Backgroundcolor',bgrnd);
set(mix,'SelectionChangeFcn',@selmix);
set(mix,'SelectedObject',[]);  % No selection
set(mix,'Visible','on','Title','Mixture Preparation');

%Inlet/Exhaust conditions button group

inlet = uibuttongroup('visible','off','Units','pixels',...
     'pos',[480 height - 190 150 100],'Backgroundcolor',bgrnd);
throttle = uicontrol('Style','checkbox','String','Throttling',...
    'pos',[5 65 140 20],'parent',inlet,'HandleVisibility','off',...
    'Backgroundcolor',bgrnd,'Callback','selthrottle');
exhaust_b = uicontrol('Style','checkbox','String','Exhaust Back Pressure',...
    'pos',[5 45 140 20],'parent',inlet,'HandleVisibility','off',...
    'Backgroundcolor',bgrnd,'Callback','selexbp');
set(inlet,'SelectedObject',[]);  % No selection
set(inlet,'Visible','on','Title','Inlet/Exhaust Conditions');

%Additional processes button group

addit = uibuttongroup('visible','off','Units','pixels',...
     'pos',[635 height - 190 150 100],'Backgroundcolor',bgrnd);
none = uicontrol('Style','Radio','String','None',...
    'pos',[5 65 140 20],'parent',addit,'HandleVisibility','off','Backgroundcolor',bgrnd);
super = uicontrol('Style','Radio','String','Supercharging',...
    'pos',[5 45 140 20],'parent',addit,'HandleVisibility','off','Backgroundcolor',bgrnd);
turbo = uicontrol('Style','Radio','String','Turbocharging',...
    'pos',[5 25 140 20],'parent',addit,'HandleVisibility','off','Backgroundcolor',bgrnd);
turbocomp = uicontrol('Style','Radio','String','Turbocompounding',...
    'pos',[5 5 140 20],'parent',addit,'HandleVisibility','off','Backgroundcolor',bgrnd);
set(addit,'SelectionChangeFcn',@seladdit);
set(addit,'SelectedObject',[]);  % No selection
set(addit,'Visible','on','Title','Additional Processes'); 

%Inputs

input_box = uibuttongroup('visible','off','Units','pixels',...
     'pos',[480 height - 700 500 475],'Backgroundcolor',bgrnd);

%Sub categories

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 435 175 20],...
    'String','Atmospheric Conditions','HorizontalAlignment','Center','Parent',input_box,...
    'FontWeight','Bold');   

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 355 175 20],...
    'String','Compression/Expansion','HorizontalAlignment','Center',...
    'Parent',input_box,'FontWeight','Bold');  

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 280 175 20],...
    'String','Manifold Conditions','HorizontalAlignment','Center','Parent',input_box,...
    'FontWeight','Bold');  
     
uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 205 175 20],...
    'String','Working Fluid','HorizontalAlignment','Center',...
    'Parent',input_box,'FontWeight','Bold'); 

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[180 205 175 20],...
    'String','Combustion','HorizontalAlignment','Center',...
    'Parent',input_box,'FontWeight','Bold'); 

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[180 435 175 20],...
    'String','Exhaust','HorizontalAlignment','Center','Parent',input_box,...
    'FontWeight','Bold'); 

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[180 355 175 20],...
    'String','Super/Turbocharging','HorizontalAlignment','Center','Parent',input_box,...
    'FontWeight','Bold'); 

%Atmospheric Temperature

input(1,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 410 80 20],...
    'String','T(atm)','HorizontalAlignment','Left','Parent',input_box);
input(1,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 414 50 20],...
    'String',defaults(1),'Parent',input_box);
input(1,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 410 60 20],...
    'String','°K','HorizontalAlignment','Left','Parent',input_box);


%Atmospheric Pressure

input(2,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 385 80 20],...
    'String','P(atm)','HorizontalAlignment','Left','Parent',input_box);
input(2,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 389 50 20],...
    'String',defaults(2),'Parent',input_box);
input(2,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 385 60 20],...
    'String','kPa','HorizontalAlignment','Left','Parent',input_box); 


%Compression Ratio

input(3,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 335 80 20],...
    'String','Comp. Ratio','HorizontalAlignment','Left','Parent',input_box);
input(3,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 339 50 20],...
    'String',defaults(3),'Parent',input_box);

%Manifold Temperature

input(6,1)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 260 80 20],...
    'String','T(intake)','HorizontalAlignment','Left','Parent',input_box);
input(6,2)=uicontrol('Style','edit','backgroundcolor',bgrnd,'pos',[85 264 50 20],...
    'String',defaults(6),'Parent',input_box);
input(6,3)=uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[140 260 60 20],...
    'String','°K','HorizontalAlignment','Left','Parent',input_box);


set(input_box,'SelectedObject',[]);  % No selection
set(input_box,'Visible','on','Title','Cycle Inputs');



%Cycle assumptions button

assump = uicontrol('Style','pushbutton','String','Cycle Assumptions','pos',...
         [790 height - 125 150 25],'Callback','cycle_assum','BackgroundColor',bgrnd);

%Preview button

preview = uicontrol('Style','pushbutton','String','Cycle Preview','pos',...
         [790 height - 158 150 25],'Callback','cycle_preview','BackgroundColor',bgrnd);
     
%Engine Parameter button         
         
eng_para = uicontrol('Style','pushbutton','String','Engine Parameters','pos',...
         [790 height - 191 150 25],'Callback','eng_para','BackgroundColor',bgrnd);       
         
%Calculate button

calc = uicontrol('Style','pushbutton','String','Cycle Calculations','pos',...
         [790 height - 224 150 25],'Callback','cycle_calc','BackgroundColor',bgrnd);         
         
%Clear runs button

clear = uicontrol('Style','pushbutton','backgroundcolor',bgrnd,'pos',[320 10 150 25],...
    'String','Clear Runs','HorizontalAlignment','Center','Parent',input_box,...
    'Callback','run_clear');  

r_default_but = uicontrol('Style','pushbutton','backgroundcolor',bgrnd,'pos',[320 43 150 25],...
    'String','Restore Defaults','HorizontalAlignment','Center','Parent',input_box,...
    'Callback','default_restore');
    
default_but = uicontrol('Style','pushbutton','backgroundcolor',bgrnd,'pos',[320 76 150 25],...
    'String','Save Defaults','HorizontalAlignment','Center','Parent',input_box,...
    'Callback','default_save');


