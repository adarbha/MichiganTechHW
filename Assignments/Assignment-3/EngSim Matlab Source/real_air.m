function [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,X]=real_air

%   Main cycle calculation program for real air cycle.  
%
%   Calculates all cycle points for a real air cycle.  Inputs are
%   acquired with global variables and get_parameters.  
%   Called by cycle_preview.m
%
%   KMF     April 27/05 Rev 1
%

global input p_v option v P species_data species_thdata calc_wait

%Parameter setup

[Tatm,Patm,Tinit,Pinit,M,vinit,rc,step,R,thetainit,thetafinal,re,Pfinal]=get_parameters;



%Initialize Super/Turbo vectors

Psuper = ones(1,12)*Pinit;
vsuper = ones(1,12)*vinit;
Pturbo = [];
vturbo = [];

   %Real Air Data
   
        species_data=[3.773; 1];    %N2, O2 mole ratio
        M = 28.848;                 %Real air molar mass
        
        species_thdata = csvread('air_thdata.txt');
        
        size_sd=size(species_data);  %Get size of species_data for for loop  

        %Initialize mixture enthalpy and entropy vectors
        
        mix_h=zeros(length(species_thdata),1);  
        mix_s=zeros(length(species_thdata),1);
        
        %Initialize counter for enthalpy, entropy (has to be incremented
        %by 3 for every i iteration)
        
        k = 2;  
        
            for i = 1:size_sd(1)
                mix_s = species_data(i,1)*species_thdata(:,k) + mix_s;    
                mix_h = species_data(i,1)*species_thdata(:,k+1) + mix_h;   
                k = k + 3;
            end
            
        %Normalize mixture enthalpy/entropy to one mole of mixture    
            
        mix_h = mix_h/sum(species_data(:,1));
        mix_s = mix_s/sum(species_data(:,1));
        
        %Temperature vector
        
        temp_d = species_thdata(:,1);

if    option(6) == 2
    
    %Supercharged
    
    dP_super = str2double(get(input(18,2),'String'));  %Get super pressure boost
    comp_eff = str2double(get(input(19,2),'String'))/100;  %Get super isen. eff.
    intercool = get(input(21,2),'Value');
    Pcompfinal = Pinit + dP_super;
    [Psuper,vsuper,Tsuper,work_super]=real_super_comp(Pinit,Tinit,...
        Pcompfinal,10,M,comp_eff,temp_d,mix_h,mix_s);
    output(2) = work_super(length(work_super));
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper));
    if intercool == 1
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        Tinit = Tinter;
        vinit = 8.314/M*Tinter/Psuper(length(Psuper));
        output(2) = output(2) + ((spline(temp_d,mix_h,(Tsuper(length(Tsuper))))...
                    -spline(temp_d,mix_h,Tinit)))/M;
        Psuper = [Psuper Psuper(length(Psuper))];
        vsuper = [vsuper vinit];
    else
    Psuper = [Psuper Psuper(length(Psuper))];
    vsuper = [vsuper vsuper(length(vsuper))];
    Tinit = Tsuper(length(Tsuper));
    end
    
elseif option(6) == 3
    
    %Turbocharged
    dP_super = str2double(get(input(18,2),'String'));  %Get super pressure boost
    comp_eff = str2double(get(input(19,2),'String'))/100;  %Get super isen. eff.
    turb_eff = str2double(get(input(20,2),'String'))/100;  %Get turbine isen. eff.
    intercool = get(input(21,2),'Value');
    Pcompfinal = Pinit + dP_super;
    [Psuper,vsuper,Tsuper,work_super]=real_super_comp(Pinit,Tinit,...
        Pcompfinal,10,M,comp_eff,temp_d,mix_h,mix_s);
    output(2) = work_super(length(work_super));
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper));
    output(5) = output(2);
    w_t_isen = output(2)/turb_eff;
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper));
    if intercool == 1   %Intercooler cools mixture back to Tinit
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        Tinit = Tinter;
        vinit = 8.314/M*Tinter/Psuper(length(Psuper));
        output(2) = output(2) + ((spline(temp_d,mix_h,(Tsuper(length(Tsuper))))...
                    -spline(temp_d,mix_h,Tinit)))/M;
        Psuper = [Psuper Psuper(length(Psuper))];
        vsuper = [vsuper vinit];
    else
    Psuper = [Psuper Psuper(length(Psuper))];
    vsuper = [vsuper vsuper(length(vsuper))];    
    Tinit = Tsuper(length(Tsuper));
    end
    


end    
        
        
        
    
waitbar(.25,calc_wait)

    %Calculate pressure, specific volume, temperature, and theta
    %vectors for real air/real mixture compression
            
    [Pcomp,vcomp,Tcomp,thetacomp]=...
    real_comp(Pinit,Tinit,rc,step,R,thetainit,...
    thetafinal,M,temp_d,mix_h,mix_s);

%Calculate compression work

output(3) = (spline(temp_d,mix_h,Tcomp(length(Tcomp)))-8.314*Tcomp(length(Tcomp))...
            -(spline(temp_d,mix_h,Tcomp(1))-8.314*Tcomp(1)))/M;
   
waitbar(.50,calc_wait)    
    
    
%Combustion
    
    %State at beginning of combustion
    vcombinit = vcomp(length(vcomp));
    Tcombinit = Tcomp(length(Tcomp));
    Pcombinit = Pcomp(length(Pcomp));
    qin = str2double(get(input(10,2),'String'));  
    if option(1) == 1   
    %Otto combustion
        cycle_type = 1;
        Pmax = 0;
    elseif option(1) == 2   
    %Diesel combustion  
        cycle_type = 2;
        Pmax = 0;
    elseif option(1) == 3   
    %Limited Pressure Combustion
        cycle_type = 3;
        Pmax = str2double(get(input(16,2),'String'));   %Max combustion pressure    
    end
    
    [Pcomb,vcomb,Tcomb]=real_air_comb(vcombinit,Pcombinit,Tcombinit,...
                        qin,R,cycle_type,Pmax,M,temp_d,mix_h,mix_s);
    if cycle_type == 1
        %Otto, no work done during combustion process (constant volume)
        w_comb = 0;
    else
        w_comb = Pcomb(length(Pcomb))*(vcomb(length(vcomb)) - vcombinit);
    end
        
    v = [vcomp vcomb];
    P = [Pcomp Pcomb];     
           
waitbar(.75,calc_wait)      
        
    %Expansion
 
    Pinitexp = P(length(P));
    Tinitexp = Tcomb(length(Tcomb));
    thetafinal = pi;
    
    %Calculate vol
    
    vclearance = min(v);
    vfinal = min(v)*re;
    if option(1) == 2 | option(1) == 3
    x1 = 0;
    x2 = pi;
    %thetacombend = fzero(@(theta) vol2theta(theta,vcomb(length(vcomb)),vclearance,rc,R),min(v)*1.5);
    func = 'vol2theta';
    thetacombend = brackroot(func,x1,x2,vcomb(length(vcomb)),vclearance,rc,R,0,0);
    thetacomb = [0 thetacombend];
    else
        thetacombend = 0;
        thetacomb = [0 0];
    end
    %Real air expansion
        [Pexp,vexp,Texp,thetaexp]=real_exp(Pinitexp,Tinitexp,vfinal,re,...
            step,R,vclearance,thetacombend,thetafinal,M,temp_d,mix_h,mix_s);
        
    %Expansion work
    
    output(4) = w_comb + (spline(temp_d,mix_h,Texp(1)) -  8.314*Texp(1)...
        - (spline(temp_d,mix_h,Texp(length(Texp))) - 8.314*Texp(length(Texp))))/M;
        
        
        %Conditions at start of blowdown
        Pinitb = Pexp(length(Pexp));
        Tinitb = Texp(length(Texp));
        
%Create main loop vectors     
        
    v_main = [v vexp];
    P_main = [P Pexp];
    T_main = [Tcomp Tcomb Texp];
    theta_main = [thetacomp thetacomb thetaexp];
        
        
        
        if Pfinal >= Pinitb
        %Exhaust back pressure cannot be higher than the pressure @ EVO    
            errordlg('Specified exhaust blowdown pressure is higher than pressure at EVO');
        end
        [Pb,vb,Tb]=real_bd(Pinitb,Tinitb,Pfinal,step,M,temp_d,mix_h,mix_s);
    
        
 %Turbocharging
    
if option(6) == 3
        h_turb = spline(temp_d,mix_h,Tb(length(Tb)))/M + w_t_isen;
        Tturb = spline(mix_h,temp_d,h_turb*M);
    i = 1;
    while Tb(i) > Tturb
        i = i+1;
    end
    blowdown = i - 1;
    Pturbo = Pb(blowdown:length(Pb));
    vturbo = vb(blowdown:length(vb));
    Tturbo = Tb(blowdown:length(Tb));
    
    Pb = Pb(1:(blowdown-1));
    vb = vb(1:(blowdown-1));
    Tb = Tb(1:(blowdown-1));
    Pfinal = Pb(length(Pb));
    
%Turbocompounding    
    elseif option(6) ==4
   
    dP_turbine = str2double(get(input(18,2),'String'));  %Get turbine delta P
    turbine_eff = str2double(get(input(19,2),'String'))/100;  %Get turbine isen. eff.
    
    Pfinal = Pfinal + dP_turbine;
    i = 1;
    while Pb(i) > Pfinal
        i = i+1;
    end
    blowdown = i-1;
    
    Pturbo = Pb(blowdown:length(Pb));
    vturbo = vb(blowdown:length(vb));
    Tturbo = Tb(blowdown:length(Tb));
    
    Pb = Pb(1:(blowdown-1));
    vb = vb(1:(blowdown-1));
    Tb = Tb(1:(blowdown-1));
    
    output(5) = (spline(temp_d,mix_h,Tturbo(1))-...
                spline(temp_d,mix_h,Tturbo(length(Tturbo))))/M;
    
    end
    
 
    %Create pumping loop/turbo/super vectors 
    if option(2) ~= 4
        %4 stroke
     v_pump = [vb(length(vb):-1:1)  vb  vturbo vturbo(length(vturbo):-1:1) vclearance vclearance ...
               vinit vsuper(length(vsuper):-1:1)];
     P_pump = [Pb(length(Pb):-1:1) Pb Pturbo Pturbo(length(Pturbo):-1:1) Pfinal Pinit Pinit...
               Psuper(length(Psuper):-1:1)];          
    else
        %2 stroke
        
     v_pump = [vb(length(vb)) vb(length(vb)) vb(length(vb)) vb(length(vb):-1:1)...
         vb vturbo vturbo(length(vturbo):-1:1) vsuper(length(vsuper):-1:1)];
     P_pump = [Pb(length(Pb)) Pb(length(Pb)) Pb(length(Pb)) Pb(length(Pb):-1:1)...
         Pb Pturbo Pturbo(length(Pturbo):-1:1) Psuper(length(Psuper):-1:1)]; 
    end      
              
 
   
    output(1) = Pinit * (vinit - vclearance);
    output(6) = Pb(length(Pb)) * (vexp(length(vexp)) - vclearance);    
    output(7) = output(1) +  output(4) + output(5) - output(2) - output(3)...
                -output(6);
    output(8) = qin;
    output(9) = output(7)/output(8);
    output(10) = vexp(length(vexp)) - vcombinit;
    output(11) = output(7)/output(10);
    output(12) = 0;
    output(13) = 0;
    %Conditions at start of compression
    
    output(14) = Pinit;
    output(15) = Tinit;
    output(16) = vcomp(1);
    
    %Conditions at start of combustion
    
    output(17) = Pcombinit;
    output(18) = Tcombinit;
    output(19) = vcombinit;
    
    %Conditions at end of combustion
    output(20) = Pcomb(length(Pcomb));
    output(21) = Tcomb(length(Tcomb));
    output(22) = vcomb(length(vcomb));
    
    %Conditions at EVO
    
    output(23) = Pexp(length(Pexp));
    output(24) = Texp(length(Texp));
    output(25) = vexp(length(vexp));
    
    %Conditions at end of blowdown
    
    output(26) = Pb(length(Pb));
    output(27) = Tb(length(Tb));
    output(28) = vb(length(vb));
    
    
    %%%%%%%%%%%%%
    theta_pump = 0;
    
    X(8,1) = 1/4.773;
    X(11,1) = 3.773/4.773;
    X = [X X];
    