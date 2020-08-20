function [P,v,T,X,comb_h,M_resid]=real_eq_comb(vinit,Pinit,Tinit,Tatm,Patm,Tfuel,phi,Test,Pest,R,cycle_type,...
                 P_max,M_resid,M_intake,M_far,f2mixcomp,temp_d,mix_h,species_data,...
                 prod_data,prod_thdata)

%   This function is used to calculate the heat addition process for
%   equilibrium cycles.  It determines whether otto, diesel, or limited
%   pressure combustion is desired and sets up the required conditions to
%   solve for the pressures and temperatures during these processes.  
%   Called by eq_comb.m
%
%   KMF     April 27/05 Rev 1
%             
                 
                 
global option input

P(1) = Pinit;
v(1) = vinit;
T(1) = Tinit;

enthalpy_2 = spline(temp_d,mix_h,Tinit);
int_energy_2 = spline(temp_d,mix_h,Tinit)-8.314*Tinit;

if option(3) == 3
    %Direct Injection
    cp_fuel = str2double(get(input(12,2),'String'));
    hf_fuel = str2double(get(input(13,2),'String'));
    dens_fuel = str2double(get(input(14,2),'String'));
    Pinj_fuel = str2double(get(input(15,2),'String'));
    
    int_energy_2 = (int_energy_2/M_intake/(1+f2mixcomp) + f2mixcomp/(1+f2mixcomp)*...
        (hf_fuel+cp_fuel*(Tfuel-298.15)+1/dens_fuel*(Pinj_fuel-Patm)))*M_far;
    
    enthalpy_2 = (enthalpy_2/M_intake/(1+f2mixcomp) + f2mixcomp/(1+f2mixcomp)*...
        (hf_fuel+cp_fuel*(Tfuel-298.15)+1/dens_fuel*(Pinj_fuel-Patm)))*M_far;
    
    v(1) = vinit/(1+f2mixcomp);    
        
end    

if cycle_type == 1  %Otto cycle

        %Temperature initial guesses for secant method
        x1 = Test;
        x2 = Test*.99;
               
        [T(2),X,comb_h] = otto_solver(x1,x2,v(1),Pest,phi,temp_d,species_data,...
            prod_data,prod_thdata,int_energy_2);
        v(2) = v(1);
        prod_data(:,1)=X;
        M_resid = sum(prod_data(:,1).*prod_data(:,2))/sum(prod_data(:,1));
        P(2) = 8.314/M_resid*T(2)/v(2);
        
elseif cycle_type == 2  %Diesel cycle

    %Temperature initial guesses for secant method
        x1 = Test;  
        x2 = Test*.99;
                        
        [T(2),X,M_resid,comb_h] = diesel_solver(x1,x2,0,P(1),phi,temp_d,species_data,...
            prod_data,prod_thdata,enthalpy_2);
        P(2) = P(1);
        v(2) = 8.314/M_resid*T(2)/P(2);
        
elseif cycle_type == 3  %Limited Pressure
        
        P(2) = P_max;
        v(2) = v(1);
        T(2) = P(2)*v(2)/(8.314/M_resid);
        Tit = T(2);
        
        %This while loop recalculates M_resid and therefore the
        %temperature at the end of constant volume combustion.
        
        merr = .001;
        err = 1;
        mit = 100;
        it = 0;
        while err > merr & it < mit
        X = eq_composition(species_data,phi,Tit,P(2),101.325);
        prod_data(:,1)=X(1:11);
        M_resid_new = sum(prod_data(:,1).*prod_data(:,2))/sum(prod_data(:,1));
        err = abs((M_resid_new-M_resid)/M_resid_new)*100;
        M_resid = M_resid_new;
        Tit = P(2)*v(2)/(8.314/M_resid);
        end
        
        enthalpy_2a = int_energy_2+P(2)*v(1)*M_resid;
                
        x1 = Test;  
        x2 = Test*.99;
        
        P(3) = P(2);
        [T(3),X1,M_resid,comb_h] = lp_solver(x1,x2,v(2),P(3),phi,temp_d,species_data,prod_data,prod_thdata,enthalpy_2a);
        v(3) = 8.314/M_resid*T(3)/P(3);
        if v(3) <= v(2)
            errordlg('Pressure limit is too high');
            v = 0;
            return;
        end  
    P = P(2:3);     %Get P,T,v all length = 2 for cycle_calc
    T = T(2:3);
    v = v(2:3);
    
end

    
    
    