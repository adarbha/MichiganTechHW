function qin=lhv(species_data,species_thdata)

%   This function is used to calculate the lower heating value for a fuel.
%   The lower heating value is required to calculate thermal efficiency of
%   fuel air cycles.  
%   Called by complete_comb.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
%

%Calculate total number of atoms of species

phi = 1;

fuel_c = sum(species_data(:,1).*species_data(:,4));
fuel_h = sum(species_data(:,1).*species_data(:,5));
fuel_o = sum(species_data(:,1).*species_data(:,6));
fuel_n = sum(species_data(:,1).*species_data(:,7));

M_fuel = sum(species_data(:,1).*species_data(:,2))/sum(species_data(:,1));

if fuel_c+fuel_h == 0
    errordlg('Please select another fuel');
    close(calc_wait);
    return;
end

air_o2 = ((fuel_c*4+fuel_h)/(2*phi)-fuel_o/2)/2;
fa = (sum(species_data(:,1).*species_data(:,2)))/(air_o2*4.773*28.966);

air_data = csvread('air_data.txt');
air_thdata = csvread('air_thdata.txt');
prod_thdata = csvread('prod_thdata.txt');
prod_data = csvread('prod_data.txt');

total_o2 = air_o2 + fuel_o/2;
prod_data(4,1) = fuel_n/2 + 3.773*air_o2;
prod_data(1,1) = 0;
prod_data(2,1) = fuel_c;
prod_data(3,1) = fuel_h/2;
prod_data(5,1) = fuel_o/2+air_o2 - prod_data(2,1) - prod_data(3,1)/2;
prod_data(6,1) = 0;

M_resid = sum(prod_data(:,1).*prod_data(:,2))/sum(prod_data(:,1));
        
        fuel_h=zeros(length(species_thdata),1);
        prod_h=zeros(length(prod_thdata),1); 
        prod_s=zeros(length(prod_thdata),1); 
        
        %Initialize counter for enthalpy, entropy (has to be incremented
        %by 3 for every i iteration)
        
        k = 2;
            h_f = species_data(:,3);
            for i = 1:length(species_data(:,1))
                fuel_h = species_data(i,1)*(h_f(i) + species_thdata(:,k+1)) + fuel_h;
            k = k+3;
            end
        
        k = 2;
            for i = 1:length(prod_data(:,1))
                prod_h = prod_data(i,1)*(prod_data(i,3)+prod_thdata(:,k+1)) + prod_h;    
                prod_s = prod_data(i,1)*prod_thdata(:,k) + prod_s;
                k = k + 3;
            end
            
        temp_d = species_thdata(:,1);            
     
 qin = (fuel_h(2) - prod_h(2))/(M_fuel*sum(species_data(:,1)));