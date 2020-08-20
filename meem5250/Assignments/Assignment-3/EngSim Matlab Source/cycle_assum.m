function cycle_assum

%   Window which displays major cycle assumptions for chosen cycle.
%
%   Displays assumptions for cycle and allows some modifications to be
%   made.  For example, Air only mixtures can be chosen to be air standard
%   or real air.
%   Callback for assump button in Engine_sim.
%
%   KMF     April 27/05 Rev 1
%

global bgrnd txtcolor option cycle_fig defaults
global mix_option ht rev m_losses

cycle_fig = figure;

% Get dimensions of screen

size = get(0,'Screensize');
width = size(3);
height = size(4);

%Set window parameters

set(gcf,'numbertitle','off','name','Cycle Assumptions');
   set(gcf,'outerposition',[1 1 width height],'color',bgrnd,'Resize','off');
   
%Set defaults for uicontrols
   set(gcf,'DefaultUicontrolFontSize',12,...
       'DefaultUicontrolFontWeight','bold',...
       'DefaultUicontrolHorizontalAlignment','left',...
       'DefaultUicontrolBackgroundcolor',bgrnd)
   
%Main Headings       
uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 height - 120 300 40],...
    'String','Combustion Process Assumptions');

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 height - 220 300 40],...
    'String','Mechanical/Thermal Assumptions');

uicontrol('Style','text','backgroundcolor',bgrnd,'pos',[5 height - 520 300 40],...
    'String','Working Fluid Assumptions');

%Change default font size for remaining uicontrols

set(gcf,'DefaultUicontrolFontSize',8,...
       'DefaultUicontrolFontWeight','normal')

%Display combustion process assumptions   
       
if length(option) == 0 
    errordlg('Please choose a combustion process at the main window.');
elseif option(1) == 0 
    errordlg('Please choose a combustion process at the main window.');
elseif option(1) == 1
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 130 600 30],...
    'String','- Immediate constant volume combustion at TDC');
elseif option(1) == 2
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 130 600 30],...
    'String','- Constant pressure combustion at end of compression pressure');
elseif option(1) == 3
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 130 600 30],...
    'String','- Immediate constant volume combustion at TDC to max pressure, then constant pressure combustion');
elseif option(1) == 4
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 130 600 30],...
    'String','- Initiate combustion at ignition crank angle, complete after burn duration');
end

%Display valve operation assumptions

uicontrol(cycle_fig,'Style','text','pos',[6 height - 235 600 30],...
    'String','Valve Operation','FontWeight','bold');

if  length(option) < 2 
    errordlg('Please choose a compression/expansion option at the main window.');
elseif option(2) == 0 
    errordlg('Please choose a compression/expansion option at the main window.');
elseif option(2) == 1 | option(2) == 2
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 250 600 30],...
    'String','- Intake valve opened instantaneously at TDC');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 265 600 30],...
    'String','- Intake valve closed instantaneously at BDC');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 280 600 30],...
    'String','- Exhaust valve opened instantaneously at BDC');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 295 600 30],...
    'String','- Exhaust valve closed instantaneously at TDC');
elseif option(2) == 3
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 250 600 30],...
    'String','- Intake valve opened instantaneously at TDC');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 265 600 30],...
    'String','- Intake valve closed instantaneously at specified crank angle');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 280 600 30],...
    'String','- Exhaust valve opened instantaneously at BDC');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 295 600 30],...
    'String','- Exhaust valve closed instantaneously at TDC');
elseif option(2) == 4
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 250 600 30],...
    'String','- 2 Stroke: No valve operation');
end

%Heat transfer assumption

uicontrol(cycle_fig,'Style','text','pos',[6 height - 319 600 30],...
    'String','Heat Transfer','FontWeight','bold');
ht=uicontrol(cycle_fig,'Style','popupmenu','pos',[100 height - 316 150 30],...
    'Backgroundcolor',txtcolor,'String',...
    'Adiabatic|Percent Heat Loss|Heat Loss Model','Value',option(8),...
    'Callback','heat_trans');

%Reversibility assumption

uicontrol(cycle_fig,'Style','text','backgroundcolor',bgrnd,'pos',[6 height - 341 600 30],...
    'String','Reversibility','FontWeight','bold');
rev=uicontrol(cycle_fig,'Style','popupmenu','pos',[100 height - 338 150 30],...
    'Backgroundcolor',txtcolor,'String',...
    'Reversible|Percent Friction Loss|Friction Model','Value',option(9),...
    'Callback','rev');

%Mass loss assumption

uicontrol(cycle_fig,'Style','text','pos',[6 height - 363 600 30],...
    'String','Mass Losses','FontWeight','bold');
m_losses=uicontrol(cycle_fig,'Style','popupmenu','pos',[100 height - 360 150 30],...
    'Backgroundcolor',txtcolor,'String','None|Cylinder Leakage','Value',option(10),...
    'Callback','mass');

%Flow assumptions

uicontrol(cycle_fig,'Style','text','pos',[6 height - 390 600 30],...
    'String','Flow Assumptions','FontWeight','bold');

uicontrol(cycle_fig,'Style','text','pos',[6 height - 405 600 30],...
    'String','- Negligible gas inertia effects');

%Throttling losses

if length(option) < 4 
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 420 600 30],...
    'String','- No intake flow loss');
elseif option(4) == 0 
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 420 600 30],...
    'String','- No intake flow loss');
elseif option(4) == 1
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 420 600 30],...
    'String','- Intake flow loss due to throttling');
end

%Exhaust back pressure

if length(option) < 5 
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 435 600 30],...
    'String','- No exhaust flow loss');

elseif option(5) == 0 
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 435 600 30],...
    'String','- No exhaust flow loss');

elseif option(5) == 1
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 435 600 30],...
    'String','- Exhaust back pressure specified');
end

%Working fluid assumptions 
uicontrol(cycle_fig,'Style','text','pos',[6 height - 535 600 30],...
    'String','- Ideal gas behaviour');
if length(option) < 3 
    errordlg('Please choose a working fluid option at the main window.');
elseif option(3) == 0
    errordlg('Please choose a working fluid option at the main window.');
elseif option(3) == 1
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 550 600 30],...
    'String','- Neglect fuel effects');
    mix_option=uicontrol(cycle_fig,'Style','popupmenu','pos',[6 height - 569 100 30],...
    'Backgroundcolor',txtcolor,'String','Air Standard|Real Air','Value',option(7));
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 595 600 30],...
    'String','- For Air Standard:');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 610 600 30],...
    'String','- Constant Specific Heats');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 625 600 30],...
    'String','- For Real Air:');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 640 600 30],...
    'String','- Variable Specific Heats');


elseif option(3) == 2
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 550 600 30],...
    'String','- Air and fuel mixed before entering cylinder');
    mix_option=uicontrol(cycle_fig,'Style','popupmenu','pos',[6 height - 569 150 30],...
    'Backgroundcolor',txtcolor,'String','Complete Combustion|Equilibrium',...
    'Value',option(7));
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 595 600 30],...
    'String','- For Equilibrium:');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 610 600 30],...
    'String','- Reaction proceeds immediately to equilibrium products and composition');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 625 600 30],...
    'String','- Composition shifts with temperature during expansion stroke');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 640 600 30],...
    'String','- Equilibrium freezes at time of exhaust valve opening (start of blowdown)');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 655 600 30],...
    'String','- Complete combustion exhaust products assumed for residual');
elseif option(3) == 3
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 550 600 30],...
    'String','- Fuel injected at TDC, only air and residual present during compression');
    mix_option=uicontrol(cycle_fig,'Style','popupmenu','pos',[6 height - 569 150 30],...
    'Backgroundcolor',txtcolor,'String','Complete Combustion|Equilibrium',...
    'Value',option(7));
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 595 600 30],...
    'String','- For Equilibrium:');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 610 600 30],...
    'String','- Reaction proceeds immediately to equilibrium products and composition');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 625 600 30],...
    'String','- Composition shifts with temperature during expansion stroke');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 640 600 30],...
    'String','- Equilibrium freezes at time of exhaust valve opening (start of blowdown)');
    uicontrol(cycle_fig,'Style','text','pos',[6 height - 655 600 30],...
    'String','- Complete combustion exhaust products assumed for residual');
end

close_but = uicontrol(cycle_fig,'Style','pushbutton','String','Ok',...
            'pos',[300 height - 690 150 30],'Callback','close_assum');











