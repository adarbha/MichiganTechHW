function rspecies_ok

%   This function creates the matrices which define the fuel species
%   composition and properties.  
%   Callback for ok button in Reactant_Species.m
%
%   KMF     April 27/05 Rev 1
%

global species_l mol_frac_return rspecies_td rtd_pathfile rs num_species
global species_thdata species_data s_data s_thdata

clear present_species species_data species_thdata mol_frac

species_l=species_l(1:num_species,:);
j = 1;
for i = 1:length(species_l)
    mol_frac(i) = str2double(get(species_l(i,2),'String'));
    if mol_frac(i) ~= 0
    present_species(j)=get(species_l(i,1),'String');
    species_data(j,1) = mol_frac(i);
    species_sheet_num(j)=i+2;
    j = j+1;
    end
end

if exist('species_data')==0
    errordlg('Please select a fuel')
    return
end

k=1;
species_thdata = ones(60,1);
h = waitbar(0,'Loading Fuel Species');
for j = 1:length(species_data)
    waitbar(j/length(present_species),h)
    [species_d(j,:)] = xlsread(rtd_pathfile,species_sheet_num(j),'c2:j2');
    species_data(j,2) = species_d(j,1);
    species_data(j,3) = species_d(j,3);
    species_data(j,4:7) = species_d(j,5:8);
    species_thdata(:,k) = xlsread(rtd_pathfile,species_sheet_num(j),'a5:a64');
    species_thdata(:,k+1) = xlsread(rtd_pathfile,species_sheet_num(j),'d5:d64');
    species_thdata(:,k+2) = xlsread(rtd_pathfile,species_sheet_num(j),'e5:e64');
    k=k+3;
    
end

mol_frac_return = mol_frac;

close(h)
close(rs)
s_data = species_data;
s_thdata = species_thdata;

