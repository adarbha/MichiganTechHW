function [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,f,M_resid,X]=complete_comb(species_data,species_thdata,stepsize)

%   Main cycle calculation program for complete combustion products
%   cycle.  
%
%   Calculates all cycle points for a fuel/air cycle with simplified,
%   complete products.  Inputs are acquired with global variables and 
%   get_parameters.  Initial guesses for residual fraction and end of 
%   combustion conditions obtained with complete_comb.  
%   Called by cycle_preview.m, eq_comb.m
%
%   KMF     April 27/05 Rev 1
%    

global input option calc_wait 
if length(species_data) < 1
    close(calc_wait)
    errordlg('Please enter the fuel composition')
    return;
end

%Get required input parameters

[Tatm,Patm,Tinit,Pinit,M,vinit,rc,stepsize,R,thetainit,thetafinal,re,Pfinal]=get_parameters;
step = 1;

%Initialize Super/Turbo vectors

Psuper = ones(1,12)*Pinit;
vsuper = ones(1,12)*vinit;
Pturbo = [];
vturbo = [];

%Get equivalence ratio

phi = str2double(get(input(11,2),'String'));


   
%Calculate total number of atoms of species

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


if air_o2 + fuel_o/2 < fuel_c/2 % Ultra Rich
    errordlg('Equivalence ratio too high')
    close(calc_wait);
    return;
    
elseif fuel_c/2 <= total_o2 & total_o2 < (fuel_c/2+fuel_h/4) % Very Rich
        
    prod_data(1,1) = fuel_c;
    prod_data(2,1) = 0;
    prod_data(3,1) = 2*total_o2 - prod_data(1,1);
    prod_data(5,1) = 0;
    prod_data(6,1) = (fuel_h - 2*prod_data(3,1))/2;
        
elseif (fuel_c/2+fuel_h/4) <= total_o2 & total_o2 < (fuel_c + fuel_h/4) % Rich
    
    prod_data(2,1) = 2*total_o2 - fuel_c - fuel_h/2;
    prod_data(1,1) = fuel_c - prod_data(2,1);
    prod_data(3,1) = fuel_h/2;
    prod_data(5,1) = 0;
    prod_data(6,1) = 0;
        
    
else % Lean/stoich
    
    prod_data(1,1) = 0;
    prod_data(2,1) = fuel_c;
    prod_data(3,1) = fuel_h/2;
    prod_data(5,1) = fuel_o/2+air_o2 - prod_data(2,1) - prod_data(3,1)/2;
    prod_data(6,1) = 0;

end

M_resid = sum(prod_data(:,1).*prod_data(:,2))/sum(prod_data(:,1));

 %Real Air Data
        air_data = csvread('air_data.txt');
        M_air = 28.848;                 %Real air molar mass
        
        air_thdata = csvread('air_thdata.txt');
        
        size_sd=size(air_data);  %Get size of species_data for for loop  

        %Initialize mixture enthalpy and entropy vectors
        
        air_h=zeros(length(air_thdata),1);  
        air_s=zeros(length(air_thdata),1);
        
        %Initialize counter for enthalpy, entropy (has to be incremented
        %by 3 for every i iteration)
        
        k = 2;  
        
            for i = 1:size_sd(1)
                air_s = air_data(i,1)*air_thdata(:,k) + air_s;    
                air_h = air_data(i,1)*air_thdata(:,k+1) + air_h;   
                k = k + 3;
            end
            
        %Normalize mixture enthalpy/entropy to one mole of mixture    
            
        air_h = air_h/sum(air_data(:,1));
        air_s = air_s/sum(air_data(:,1));
        
        %Temperature vector
        
        temp_d = air_thdata(:,1);

if    option(6) == 2
    
    %Supercharged
    
    dP_super = str2double(get(input(18,2),'String'));  %Get super pressure boost
    comp_eff = str2double(get(input(19,2),'String'))/100;  %Get super isen. eff.
    intercool = get(input(21,2),'Value');
    Pcompfinal = Pinit + dP_super;
    [Psuper,vsuper,Tsuper,work_super]=real_super_comp(Pinit,Tinit,...
        Pcompfinal,10,M_air,comp_eff,temp_d,air_h,air_s);
    output(2) = work_super(length(work_super));
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper))*1/(1+fa);    %Fuel injected after supercharger
    if intercool == 1
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        Tinit = Tinter;
        vinit = 8.314/M*Tinter/Psuper(length(Psuper));
        output(2) = output(2) + ((spline(temp_d,air_h,(Tsuper(length(Tsuper))))...
                    -spline(temp_d,air_h,Tinit)))/M;
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
        Pcompfinal,10,M_air,comp_eff,temp_d,air_h,air_s);
    output(2) = work_super(length(work_super));
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper))*1/(1+fa);    %Fuel injected after supercharger
    if intercool == 1   %Intercooler cools mixture back to Tinit
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        Tinit = Tinter;
        %Fuel injected after supercharger
        vinit = 8.314/M*Tinter/Psuper(length(Psuper))*1/(1+fa);
        %Supercharger work includes work lost to intercooling
        output(2) = output(2) + ((spline(temp_d,air_h,(Tsuper(length(Tsuper))))...
                    -spline(temp_d,air_h,Tinit)))/M;
        Psuper = [Psuper Psuper(length(Psuper))];
        vsuper = [vsuper vinit];
    else
    Psuper = [Psuper Psuper(length(Psuper))];
    vsuper = [vsuper vsuper(length(vsuper))];    
    Tinit = Tsuper(length(Tsuper));
    end

end    

%Heywood's equations

Tr = 1400;

f = (1 + Tr/Tinit*(rc*(Pinit/Pfinal)-(Pinit/Pfinal)^.24))^-1;
T1 = Tr*rc*f*(Pinit/Pfinal);


waitbar(.25,calc_wait) 

%Set criteria for residual iteration

maxerr=0.1;
err = 1;
maxit=25;
it = 1;

%This while loop iterates to find f. 

while it <= maxit
    
if err >= maxerr
else
    it = maxit;
    step = stepsize;
end
    
f2mcomp = fa*(1-f);


%Compression process
%Creates a vector comp_comp with the composition of the compression mixture
%including residual.  If the fuel is pre-mixed, the fuel is included in
%this vector.  Otherwise, only air and residual gases are included.

if option(3) == 2 
    %fuel+ air+ residual
    M_intake = (sum(species_data(:,1).*species_data(:,2))...
    +air_o2*sum(air_data(:,1).*air_data(:,2)))/...
    (sum(species_data(:,1))+air_o2*sum(air_data(:,1)));
    
    M_fuelair = M_intake;
    
    resid_mol_frac = f/(f+(1-f)*(M_resid/M_intake));
    
    comp_comp = [(1-resid_mol_frac)*species_data(:,1);...
                 (1-resid_mol_frac)*air_o2*air_data(:,1);...
                 resid_mol_frac*prod_data(:,1)];
             
    h_f = [species_data(:,3);air_data(:,3);prod_data(:,3)];
     
    thdata = [species_thdata air_thdata prod_thdata];           

elseif option(3) == 3
    %air + residual only
    M_fuelair = (sum(species_data(:,1).*species_data(:,2))...
    +air_o2*sum(air_data(:,1).*air_data(:,2)))/...
    (sum(species_data(:,1))+air_o2*sum(air_data(:,1)));
    
    M_intake = (air_o2*sum(air_data(:,1).*air_data(:,2)))/...
    (sum(species_data(:,1))+air_o2*sum(air_data(:,1)));
    
    resid_mol_frac = f/(f+(1-f)*(M_resid/M_intake));        
            
    comp_comp = [(1-resid_mol_frac)*air_o2*air_data(:,1);...
        resid_mol_frac*prod_data(:,1)];
    
     h_f = [air_data(:,3);prod_data(:,3)];
     
    thdata = [air_thdata prod_thdata];
end


y = f/(f+(1-f)*(M_resid/M_intake));
M_far = y*M_resid+(1-y)*M_fuelair;

%Compression mixture molar mass

M_comp = (1-f)*M_intake + f*M_resid;

    % Initialize mixture enthalpy and entropy vectors
        
        %Intake mixture enthalpy... required for calculating T1
    
        intake_h=zeros(length(thdata),1);
    
        %Compression mixture enthalpy/entropy... required for calculating
        %properties during compression process, and the state at the
        %beginning of combustion
        
        mix_h=zeros(length(thdata),1);  
        mix_s=zeros(length(thdata),1);
        
        %Product mixture enthalpy/entropy... required for calculating
        %conditions at the end of combustion and points during the
        %expansion/blowdown process
        
        prod_h=zeros(length(prod_thdata),1); 
        prod_s=zeros(length(prod_thdata),1); 
        
        %Initialize counter for enthalpy, entropy (has to be incremented
        %by 3 for every i iteration)
        
        k = 2;
            prod_num = size(prod_data);
            for i = 1:length(comp_comp)-prod_num(1)
                intake_h = comp_comp(i,1)*(h_f(i) + thdata(:,k+1)) + intake_h;
            k = k+3;
            end
        
        k = 2;  
            for i = 1:length(comp_comp)
                mix_h = comp_comp(i,1)*(h_f(i) + thdata(:,k+1)) + mix_h;
                mix_s = comp_comp(i,1)*thdata(:,k) + mix_s; 
                k = k + 3;
            end
        
        k = 2;
        
            for i = 1:length(prod_data(:,1))
                prod_h = prod_data(i,1)*(prod_data(i,3)+prod_thdata(:,k+1)) + prod_h;    
                prod_s = prod_data(i,1)*prod_thdata(:,k) + prod_s;
                k = k + 3;
            end
            
        %Normalize mixture enthalpy/entropy to one mole of mixture    
        
        intake_h = intake_h/sum(comp_comp(1:length(comp_comp)-prod_num(1),1));
        
        mix_h = mix_h/sum(comp_comp(:,1));
        mix_s = mix_s/sum(comp_comp(:,1));
        
        prod_h = prod_h/sum(prod_data(:,1));
        prod_s = prod_s/sum(prod_data(:,1));
        
        %Temperature vector
        
        temp_d = thdata(:,1);            
        prod_t = prod_thdata(:,1);      
        
%Compression        
v1 = 8.314/M_comp*T1/Pinit;

[Pcomp,vcomp,Tcomp,thetacomp]=real_comp(Pinit,T1,rc,step,R,thetainit,thetafinal,M_comp,temp_d,mix_h,mix_s);

%Calculate compression work

if option(3) == 2
    %Premixed
    output(3) = (spline(temp_d,mix_h,Tcomp(length(Tcomp)))-8.314*Tcomp(length(Tcomp))...
            -(spline(temp_d,mix_h,Tcomp(1))-8.314*Tcomp(1)))/M_comp;
else
    %Direct Injection
    output(3) = (spline(temp_d,mix_h,Tcomp(length(Tcomp)))-8.314*Tcomp(length(Tcomp))...
            -(spline(temp_d,mix_h,Tcomp(1))-8.314*Tcomp(1)))/M_comp;
end

waitbar(.50,calc_wait) 
%Combustion process

    vcombinit = vcomp(length(vcomp));
    Tcombinit = Tcomp(length(Tcomp));
    Pcombinit = Pcomp(length(Pcomp));
    if option(1) == 1   
    %Otto combustion
        cycle_type = 1;
        P_max = 0;
    elseif option(1) == 2   
    %Diesel combustion  
        cycle_type = 2;
        P_max = 0; 
    elseif option(1) == 3   
    %Limited Pressure Combustion
        cycle_type = 3;
        P_max = str2double(get(input(16,2),'String'));   %Max combustion pressure    
    end

[Pcomb,vcomb,Tcomb]=real_complete_comb(vcombinit,Pcombinit,Tcombinit,Tatm,Patm,Tinit,R,cycle_type,...
        P_max,M_resid,M_intake,M_far,f2mcomp,temp_d,mix_h,prod_t,prod_h);
if vcomb == 0
    close(calc_wait);
    return;
end    
        
%Calculate work done during constant pressure combustion process    
        
if cycle_type == 1
        %Otto, no work done during combustion process (constant volume)
        w_comb = 0;
    else
        w_comb = Pcomb(length(Pcomb))*(vcomb(length(vcomb)) - vcombinit);
    end    
        
        
P = [Pcomp Pcomb];
v = [vcomp vcomb];
T = [Tcomp Tcomb];
%Expansion
 
    Pinitexp = P(length(P));
    Tinitexp = T(length(T));
    thetafinalexp = pi;
    
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
        [Pexp,vexp,Texp,thetaexp]=real_exp(Pinitexp,Tinitexp,vfinal,re,step,...
            R,vclearance,thetacombend,thetafinalexp,M_resid,prod_t,prod_h,prod_s);
        
 
%Calculate expansion work

if option(3) == 2
    %Premixed fuel/air
    output(4) = w_comb + (spline(temp_d,prod_h,Texp(1))-...
        8.314*Texp(1)-(spline(temp_d,prod_h,Texp(length(Texp)))...
        -8.314*Texp(length(Texp))))/M_resid;
       
elseif option(3) == 3
    %Direct Injected fuel
    %Work corrected to mixture at state 1
    output(4) = (w_comb + (spline(temp_d,mix_h,Texp(1))-...
        8.314*Texp(1)-(spline(temp_d,mix_h,Texp(length(Texp)))...
        -8.314*Texp(length(Texp))))/M_resid)*(1+(1-f)*fa);
    
end           
            
            
        %Conditions at start of blowdown
        Pinitb = Pexp(length(Pexp));
        Tinitb = Texp(length(Texp));
        
        if Pfinal >= Pinitb
        %Exhaust back pressure cannot be higher than the pressure @ EVO    
            errordlg('Specified exhaust blowdown pressure is higher than pressure at EVO');
        end
        [Pb,vb,Tb]=real_bd(Pinitb,Tinitb,Pfinal,step,M_resid,prod_t,prod_h,prod_s);

v5 = max(vb);
T5 = Tb(length(Tb));
fnew = vclearance/max(vb);
% Tcomb = max(T);
err = abs((fnew - f)/fnew)*100;
it = it + 1;
f = fnew;
y = f/(f+(1-f)*(M_resid/M_intake));
M_mix = y*M_resid+(1-y)*M_intake;
h5 = spline(prod_t,prod_h,T5)/M_resid;
hi = spline(temp_d,intake_h,Tinit)/M_intake;
h1 = (f*(h5+(Pinit - Pfinal)*v5)+(1-f)*hi)*M_mix;
T1 = spline(mix_h,temp_d,h1);
v1 = 8.314/M_mix*T1/Pinit;
waitbar(.75,calc_wait) 

end

%Create main loop vectors     
        
v_main = [v vexp];
P_main = [P Pexp];
T_main = [Tcomp Tcomb Texp];
theta_main = [thetacomp thetacomb thetaexp];   

  
        
 %Turbocharging
    
if option(6) == 3
    %Calculate required turbine work
        output(5) = output(2);
        %Output, corrected to mixture at exhaust
        w_t_isen = output(5)/turb_eff/(1+(1-f)*fa);    
        h_turb = spline(temp_d,mix_h,Tb(length(Tb)))/M_resid + w_t_isen;
        Tturb = spline(mix_h,temp_d,h_turb*M_resid);
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
    %Output, corrected to mixture at point 1
    output(5) = (spline(temp_d,mix_h,Tturbo(1))-...
                spline(temp_d,mix_h,Tturbo(length(Tturbo))))/M_resid*(1+(1-f)*fa);
    
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
              
 
    %Intake work
    output(1) = Pinit * (v1 - vclearance);
    %Convert super work to mixture mass
    output(2) = output(2)*1/(1+fa)*(1-f);
    %Exhaust work
    output(6) = Pb(length(Pb)) * (vexp(length(vexp)) - vclearance);
    %Net work
    output(7) = output(1) +  output(4) + output(5) - output(2) - output(3)...
                -output(6);     
    % Calc LHV for fuel          
    output(8) = lhv(species_data,species_thdata);   
    %Expansion volume
    output(10) = vexp(length(vexp)) - vcombinit;
    if option(3) == 2   
        %Thermal Efficiency (premixed)
        output(9) = output(7)*(1+fa)/(fa*(1-f)*output(8));
        %IMEP
        output(11) = output(7)/output(10);
    else    
        %Thermal Efficiency (D.I.)
        output(9) = output(7)/(fa*(1-f)*output(8));
        %IMEP
        output(11) = output(7)/((1+fa)*output(10));
    end
    %residual
    output(12) = f;
    %Fuel Air Ratio
    output(13) = fa;
   %Conditions at start of compression
    
    output(14) = Pinit;
    output(15) = T1;
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
 
    t_mol = sum(prod_data(:,1));
    X(6,1) = prod_data(1,1)/t_mol;
    X(10,1) = prod_data(2,1)/t_mol;
    X(9,1) = prod_data(3,1)/t_mol;
    X(11,1) = prod_data(4,1)/t_mol;
    X(8,1) = prod_data(5,1)/t_mol;
    X(4,1) = prod_data(6,1)/t_mol;
    X = [X X];
    