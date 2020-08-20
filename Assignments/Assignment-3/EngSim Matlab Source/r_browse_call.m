function r_browse_call

%   This function is used to select a different file to get fuel species
%   from.  
%   Callback for browse_but button in Reactant_Species.m
%
%   KMF     April 27/05 Rev 1
%
global rtd_file bgrnd species_l rtd_pathfile num_species

[rtd_filename rtd_path] = uigetfile('*.xls');

if rtd_filename == 0
else
rtd_pathfile = [rtd_path rtd_filename];
    set(rtd_file,'String',rtd_pathfile);
end

%Species List Code

if rtd_pathfile ~= 0
    [num, species_list] = xlsread(rtd_pathfile,'Species','b3:b53');

    num_species = length(species_list);
        
    for i = 1:num_species
        if i <= 20
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.05 (.88-.04*i) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String','0','Position',...
            [.2 (.885-.04*i) .1 .04],'HorizontalAlignment','Left',...
            'FontSize',10,'BackgroundColor',bgrnd);
        elseif i <=40
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.35 (.88-.04*(i-20)) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String','0','Position',...
            [.5 (.885-.04*(i-20)) .1 .04],'HorizontalAlignment','Left',...
            'FontSize',10,'BackgroundColor',bgrnd);
        else
        species_l(i,1) = uicontrol('Style','Text','String',species_list(i),...
            'Position',[.65 (.88-.04*(i-40)) .15 .04],'HorizontalAlignment',...
            'Left','FontSize',10,'BackgroundColor',bgrnd);
        species_l(i,2) = uicontrol('Style','edit','String','0','Position',...
            [.8 (.885-.04*(i-40)) .1 .04],'HorizontalAlignment','Left',...
            'FontSize',10,'BackgroundColor',bgrnd);
        end
    end
    if length(species_l)>num_species
        for i = (num_species + 1):length(species_l)
            delete(species_l(i,:))
        end
    end
end

