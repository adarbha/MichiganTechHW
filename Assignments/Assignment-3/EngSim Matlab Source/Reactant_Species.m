function Reactant_Species

%   This function creates a window to select fuel composition.
%   Species file is defined as shown in COMB_template.xls.
%   Callback for Fuel Composition button.
%
%   KMF     April 27/05 Rev 1
%

global rtd_pathfile rtd_path rtd_file bgrnd rs
global species_l mol_frac_return num_species

rs = figure;

set(gcf,'DefaultUicontrolUnits','Normalized','numbertitle','off','name',...
    'Reactant Species Selection');
set(gcf,'Units','normalized','outerposition',[.25 .05 .5 .9],'color',bgrnd,...
    'Resize','off');
   
rtd_file = uicontrol(gcf,'Style','Text','Position',[0.05 0.88 0.45 0.07],...
          'BackgroundColor',bgrnd,...
          'HorizontalAlignment','Right','Fontsize',12,'String',rtd_pathfile);


browse_but = uicontrol(gcf,'Style','Pushbutton','String','Get Species File...',...
             'Value',0,'Position',[0.55 0.905 0.4 0.05],'BackgroundColor',bgrnd,...
             'Callback','r_browse_call','Fontsize',12);


%Species List Code


if rtd_pathfile ~= 0
    [num, species_list] = xlsread(rtd_pathfile,'Species','b3:b53');
num_species = length(species_list);
    
    for i = 1:num_species
        if i <= 20
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.05 (.88-.04*i) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String',...
            num2str(mol_frac_return(i)),'Position',[.2 (.885-.04*i) .1 .04],...
            'HorizontalAlignment','Left','FontSize',10,'BackgroundColor',bgrnd);
        elseif i <=40
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.35 (.88-.04*(i-20)) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String',...
            num2str(mol_frac_return(i)),'Position',...
            [.5 (.885-.04*(i-20)) .1 .04],'HorizontalAlignment','Left',...
            'FontSize',10,'BackgroundColor',bgrnd);
        else
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.65 (.88-.04*(i-40)) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String',...
            num2str(mol_frac_return(i)),'Position',...
            [.8 (.885-.04*(i-40)) .1 .04],'HorizontalAlignment','Left',...
            'FontSize',10,'BackgroundColor',bgrnd);
        end
    end
    if length(species_l)>num_species
        for i = (num_species + 1):length(species_l)
            delete(species_l(i,1))
            delete(species_l(i,2))
        end
    end
end

             
             
             
ok_but = uicontrol(gcf,'Style','Pushbutton','String','Ok',...
             'Value',0,'Position',[0.25 0.015 0.2 0.05],'BackgroundColor',bgrnd,...
             'Callback','rspecies_ok','Fontsize',12);
         
cancel_but = uicontrol(gcf,'Style','Pushbutton','String','Cancel',...
             'Value',0,'Position',[0.55 0.015 0.2 0.05],'BackgroundColor',bgrnd,...
             'Callback','cancel_but','Fontsize',12);