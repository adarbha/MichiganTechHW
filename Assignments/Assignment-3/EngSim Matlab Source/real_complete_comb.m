function [P,v,T]=real_eq_comb(vinit,Pinit,Tinit,Tatm,Patm,Tfuel,R,cycle_type,...
                 P_max,M_resid,M_intake,M_far,f2mixcomp,temp_d,mix_h,prod_t,prod_h)

             
%   This function is used to calculate the heat addition process for
%   complete combustion cycles.  It determines whether otto, diesel, or limited
%   pressure combustion is desired and sets up the required conditions to
%   solve for the pressures and temperatures during these processes.  
%   Called by complete_comb.m
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
        
        %Function for finding final temperature after combustion
        func = 'real_ottoc';
        
        %Temperature initial guesses for secant method
        x1 = T(1);
        x2 = T(1)*1.1;
               
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,prod_t,prod_h,int_energy_2,Tinit);
        v(2) = v(1);
        P(2) = 8.314/M_resid*T(2)/v(2);
   
        
elseif cycle_type == 2  %Diesel cycle
        
        %Function for finding final temperature after combustion
        func = 'real_dieselc';
        
        %Temperature initial guesses for secant method
        x1 = T(1);  
        x2 = T(1)*1.1;
                        
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,prod_t,prod_h,enthalpy_2,Tinit);
        P(2) = P(1);
        v(2) = 8.314/M_resid*T(2)/P(2);
        
elseif cycle_type == 3  %Limited Pressure
        
        %Function for finding final temperature after combustion
        func = 'real_lpc';
        
        P(1) = P_max;
        T(1) = P(1)*v(1)/(8.314/M_resid);
        enthalpy_2a = int_energy_2+P(1)*v(1)*M_resid;
                
        x1 = T(1);
        x2 = T(1)*1.1;
        
        P(2) = P(1);
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,prod_t,prod_h,enthalpy_2a,Tinit);
        v(2) = 8.314/M_resid*T(2)/P(2);
        if v(2) <= v(1)
            errordlg('Pressure limit is too high');
            v = 0;
            return;
        end  
    
    
end

    
    
    