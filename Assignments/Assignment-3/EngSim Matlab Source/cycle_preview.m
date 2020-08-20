function     [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,...
              X] = cycle_preview

%This function provides a preview of the P-v diagram on the main screen of
%the engine_sim program and shows the previous cycle as well. 

global input p_v option v P v_pump2 P_pump2 species_data species_thdata calc_wait 
global s_data s_thdata
calc_wait = waitbar(0,'Creating Cycle Diagram');

vold = v;
Pold = P;
voldpump =v_pump2;
Poldpump = P_pump2;



if option(3) == 1 & option(7) == 1
   %Air Standard
[P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,X] = air_standard;
        
%End Air Standard   
     
    
elseif option(3) == 1 & option(7) == 2 
   %Real Air
[P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,X] = real_air;    
      


elseif option(3) == 2 & option(7) == 1
    %Complete, premixed combustion
    [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,f,...
        M_resid,X]=complete_comb(s_data,s_thdata,100); 
elseif option(3) == 3 & option(7) == 1
    %Complete, direct injection combustion    
    [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,f...
        ,M_resid,X]=complete_comb(s_data,s_thdata,100);
elseif option(3) == 2 & option(7) == 2
    %Premixed combustion w/ equilibrium products
    [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,f,...
        M_resid,X]=eq_comb(s_data,s_thdata);
elseif option(3) == 3 & option(7) == 2
    %Direct injection combustion w/ equilibrium products
    [P_main,v_main,T_main,theta_main,P_pump,v_pump,theta_pump,output,f,...
        M_resid,X]=eq_comb(s_data,s_thdata);
end

waitbar(1.00,calc_wait) 

%Create P and v vectors for plotting
    

    v = v_main;
    P = P_main;

    v_pump2 = v_pump;
    P_pump2 = P_pump;
    
%Plot preview of P-v diagram

close(calc_wait); 
    plot(p_v,v_main,P_main,'b-',v_pump,P_pump,'b:');
    axis(p_v,[0 max([max(v) max(vold)])*1.25 0 max([max(P) max(Pold)])*1.1]);
    title(p_v,'Pressure - Volume');
    xlabel(p_v,'Specific Volume');
    ylabel(p_v,'Pressure');

%Plot previous cycle

    if exist('vold')
        hold on;
        plot(p_v,vold,Pold,'r--',voldpump,Poldpump,'r--');
        hold off;
    end
legend('Main Loop','Pumping Loop','Previous Cycle');
    
    