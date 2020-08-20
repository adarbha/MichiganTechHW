function [P,v,T]=real_air_comb(vinit,Pinit,Tinit,qin,R,cycle_type,P_max,M,temp_d,mix_h,mix_s)

%   This function is used to calculate the heat addition process for
%   real air cycles.  It determines whether otto, diesel, or limited
%   pressure combustion is desired and sets up the required conditions to
%   solve for the pressures and temperatures during these processes.  
%   Called by real_air.m
%
%   KMF     April 27/05 Rev 1
%             


P(1) = Pinit;
v(1) = vinit;
T(1) = Tinit;
theta(1) = 0;

enthalpy_2 = spline(temp_d,mix_h,Tinit);
int_energy_2 = spline(temp_d,mix_h,Tinit)-8.314*Tinit;


if cycle_type == 1  %Otto cycle
        
        %Function for finding final temperature after combustion
        func = 'real_air_ottoc';
        
        %Temperature initial guesses for secant method
        x1 = T(1);
        x2 = T(1)*1.1;
               
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,qin,M,int_energy_2,Tinit);
        v(2) = v(1);
        P(2) = 8.314/M*T(2)/v(2);
   
        
elseif cycle_type == 2  %Diesel cycle
        
        %Function for finding final temperature after combustion
        func = 'real_air_dieselc';
        
        %Temperature initial guesses for secant method
        x1 = T(1);  
        x2 = T(1)*1.1;
                        
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,qin,M,enthalpy_2,Tinit);
        P(2) = P(1);
        v(2) = 8.314/M*T(2)/P(2);
        
elseif cycle_type == 3  %Limited Pressure
        
        %Function for finding final temperature after combustion
        func = 'real_air_lpc';
        
        P(1) = P_max;
        T(1) = P(1)*v(1)/(8.314/M);
        enthalpy_2a = spline(temp_d,mix_h,T(1));
        int_energy_2a = enthalpy_2a - 8.314*T(1);
        qin_cp = qin*M - (int_energy_2a-int_energy_2);
                
        x1 = T(1);
        x2 = T(1)*1.1;
        
        P(2) = P(1);
        T(2) = Secroot(func,x1,x2,temp_d,mix_h,qin_cp,enthalpy_2a,Tinit,M);
        v(2) = 8.314/M*T(2)/P(2);
        if v(2) <= v(1)
            errordlg('Pressure limit is too high');
            return;
        end  
    
    
end

          
    
    
    