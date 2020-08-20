function [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,X]=air_standard

%   Main cycle calculation program for air standard cycle.  
%
%   Calculates all cycle points for an air standard cycle.  Inputs are
%   acquired with global variables and get_parameters.  
%   Called by cycle_preview.m, knock_sim.m
%
%   KMF     April 27/05 Rev 1
%


global input option k vinit rc R qin ts tb calc_wait
%Parameter setup

[Tatm,Patm,Tinit,Pinit,M,vinit,rc,step,R,thetainit,thetafinal,re,Pfinal]=get_parameters;

if input(8,2) == 0
    close(calc_wait); 
    errordlg('Please choose a mixture preparation');
    return;
end

    Cp = str2double(get(input(8,2),'String'));  %Get Cp value
    Cv = str2double(get(input(9,2),'String'));  %Get Cv value
            
    k = Cp/Cv;  %Specific heat ratio

    qin = str2double(get(input(10,2),'String'));

%Initialize Super/Turbo vectors

Psuper = ones(1,12)*Pinit;
vsuper = ones(1,12)*vinit;
Pturbo = [];
vturbo = [];
    
    
    
if    option(6) == 2
    
    %Supercharged
    
    dP_super = str2double(get(input(18,2),'String'));  %Get super pressure boost
    comp_eff = str2double(get(input(19,2),'String'))/100;  %Get super isen. eff.
    intercool = get(input(21,2),'Value');    
    Psuper = Pinit:dP_super/10:(Pinit+dP_super);
    vsuper = (Pinit./Psuper).^(1/k).*vinit;
    work_super = (Psuper.*vsuper-Pinit.*vinit)./(k-1)./comp_eff;
    output(2) = work_super(length(work_super));
    Tsuper = work_super./Cp + Tinit;
    vsuper = 8.314/M*Tsuper./Psuper;
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper));

    if intercool == 1
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        vinit = 8.314/M*Tinter/Psuper(length(Psuper));
        output(2) = output(2) + Cp*(Tsuper(length(Tsuper))-Tinit);
        Psuper = [Psuper Psuper(length(Psuper))];
        vsuper = [vsuper vinit];
    else
    Psuper = [Psuper Psuper(length(Psuper))];
    vsuper = [vsuper vsuper(length(vsuper))];
    end
    Tinit = M/8.314*vinit*Pinit;
    
elseif option(6) == 3
    
    %Turbocharged
    
    dP_super = str2double(get(input(18,2),'String'));  %Get boost P
    comp_eff = str2double(get(input(19,2),'String'))/100;  %Get compressor isen. eff.
    turb_eff = str2double(get(input(20,2),'String'))/100;  %Get turbine isen. eff.
    intercool = get(input(21,2),'Value');
        
    Psuper = Pinit:dP_super/10:(Pinit+dP_super);
    vsuper = (Pinit./Psuper).^(1/k).*vinit;
    work_super = (Psuper.*vsuper-Pinit.*vinit)./(k-1)./comp_eff;
    output(2) = work_super(length(work_super));
    output(5) = output(2);
    w_t_isen = output(2)/turb_eff;
    Tsuper = work_super./Cp + Tinit;
    vsuper = 8.314/M.*Tsuper./Psuper;
    Pinit = Psuper(length(Psuper));
    vinit = vsuper(length(vsuper));
    
    if intercool == 1
        Tinter = str2double(get(input(22,2),'String'));  %Get Intercooler Temp value
        vinit = 8.314/M*Tinter/Psuper(length(Psuper));
        output(2) = output(2) + Cp*(Tsuper(length(Tsuper))-Tinit);
        Psuper = [Psuper Psuper(length(Psuper))];
        vsuper = [vsuper vinit];
    else
    Psuper = [Psuper Psuper(length(Psuper))];
    vsuper = [vsuper vsuper(length(vsuper))];
    end
    Tinit = M/8.314*vinit*Pinit;
end    
    
if option(1) == 4
    %Arbitrary Heat Release

    ts = str2double(get(input(25,2),'String'));  %Get ts value
    tb = str2double(get(input(26,2),'String'));  %Get tb value

    ts=ts*pi/180;        %spark timing in radians ABDC (160°ABDC = 20°BTDC)
    tb=tb*pi/180;          %combustion duration in radians (50°)
    
    theta_main = [-pi:(2*pi)/103:pi];    

    [theta_main,P_main] = ode45('dPdt',theta_main,Pinit);
    
    v_main = vinit/rc * (1+(rc-1)/2*(R+1-cos(theta_main)...
             -sqrt(R^2-(sin(theta_main)).^2))); 
    v_main = v_main';
    P_main = P_main';
    T_main = M/8.314.*v_main.*P_main; 
    vclearance = min(v_main);
    Pinitb = P_main(length(P_main));
    Tinitb = T_main(length(T_main));
    vexp = vinit;
    [vmin,minindex] = min(v_main);
    output(3) = trapuneven(v_main(minindex:-1:1),P_main(minindex:-1:1));
    output(4) = trapuneven(v_main(minindex:length(v_main)),...
        P_main(minindex:length(P_main)));
    
else

           
        %Calculate pressure, specific volume, temperature, and theta
        %vectors for air standard compression
            
        [Pcomp,vcomp,Tcomp,thetacomp]=...
        air_stand_comp(Pinit,Tinit,rc,k,M,step,R,thetainit,thetafinal);
    
        %Combustion
            
        vcombinit = vcomp(length(vcomp));
        Tcombinit = Tcomp(length(Tcomp));
        Pcombinit = Pcomp(length(Pcomp));  
        
        %Calculate compression work 
        
        output(3) = Cv * (Tcombinit - Tinit);
        
        if option(1) == 1   
        %Otto
            [Pcomb,vcomb,Tcomb] =...
            air_stand_otto_heat_addition(Tcombinit,vcombinit,qin,Cv,M);
        
        %Work during combustion process is 0 (no volume change)    
        w_comb = 0;    
        
        elseif option(1) == 2
        %Diesel
            [vcomb,Tcomb] = air_stand_diesel_heat_addition(Tcombinit,Pcombinit,qin,Cp,M);
            Pcomb = [Pcombinit Pcombinit];
        
        %Combustion process work
        
        w_comb = Pcomb(1)*(vcomb(2)-vcombinit);
            
        elseif option(1) == 3
        %Limited Pressure
            Pmax = str2double(get(input(16,2),'String'));   %Max combustion pressure
            [vfinal,Tfinal,Tcv] = air_stand_lp_heat_addition(Tcombinit,vcombinit,...
                                  Pmax,qin,Cp,Cv,M);
            vcomb = [vcombinit vfinal];
            Pcomb = [Pmax Pmax];
            Tcomb = [Tcv Tfinal];
            if vfinal <= vcombinit
            errordlg('Pressure limit is too high');
            return;         
            end  
        
        %Combustion process work
        w_comb = Pmax*(vcomb(2) - vcomb(1));    
        end
       
    v = [vcomp vcomb];
    P = [Pcomp Pcomb];
         
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
    func = 'vol2theta';
    thetacombend = brackroot(func,x1,x2,vcomb(length(vcomb)),vclearance,rc,R,0,0);
    thetacomb = [0 thetacombend];
    else
        thetacombend = 0;
        thetacomb = [0 0];
    end
    
    v = [vcomp vcomb];
    P = [Pcomp Pcomb];
  
    [Pexp,vexp,Texp,thetaexp]=air_stand_exp(Pinitexp,Tinitexp,vfinal,k,M,...
    step,re,R,vclearance,thetacombend,thetafinal);
         
    %Conditions at start of blowdown
    Pinitb = Pexp(length(Pexp));
    Tinitb = Texp(length(Texp));
       
    %Expansion work
    
    output(4) = w_comb + Cv*(Tinitexp - Tinitb);
    
    v_main = [v vexp];
    P_main = [P Pexp];
    T_main = [Tcomp Tcomb Texp];
    theta_main = [thetacomp thetacomb thetaexp];
end

%Blowdown

    if Pfinal >= Pinitb
        errordlg('Specified exhaust blowdown pressure is higher than pressure at EVO');
    end
    [Pb,vb,Tb]=air_stand_blowdown(Pinitb,Tinitb,Pfinal,k,M,step);

%Turbocharging
    
    if option(6) == 3
       
        Tturb = Tb(length(Tb)) + w_t_isen/Cp;
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
    
    output(5) = (Pturbo(1)*vturbo(1)-Pturbo(length(Pturbo))*vturbo(length(vturbo)))...
                /(k-1)*turbine_eff;
    
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
     
    if option(2) ~= 4
        output(1) = Pinit * (vinit - vclearance);    
        output(6) = Pb(length(Pb)) * (vexp(length(vexp)) - vclearance);
        else
            output(1) = 0;
            output(6) = 0;
    end
        
    %Net work calculation
    output(7) = output(1) +  output(4) + output(5) - output(2) - output(3)...
                -output(6);
    output(8) = qin;
    output(9) = output(7)/output(8);    
    output(10) = vexp(length(vexp)) - vclearance;
    output(11) = output(7)/output(10);
    %Conditions at start of compression
    if option(1) ~=4
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
       
    else
    output(14) = Pinit;
    output(15) = Tinit;
    output(16) = vinit;
    [output(19),minindex] = min(v_main);
    output(17) = P_main(minindex);
    output(18) = T_main(minindex);
    [output(20),maxindex] = max(P_main);
    output(21) = T_main(maxindex);
    output(22) = v_main(maxindex);
    output(23) = P_main(length(P_main));
    output(24) = T_main(length(T_main));
    output(25) = v_main(length(v_main));
    output(26) = Pb(length(Pb));
    output(27) = Tb(length(Tb));
    output(28) = vb(length(vb));
    end
    output(12) = 0;
    output(13) = 0;
    
    %%%%%%%%%%%%%
    theta_pump = 0;
    X = zeros(11,1);
    X = [X X];
    
    