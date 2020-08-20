function [Tatm,Patm,Tinit,Pinit,M,vinit,rc,step,R,thetainit,thetafinal,re,Pfinal]=get_parameters

%   Get parameters function 
%
%   This function is used to transfer common inputs to the various cycles.
%   The inputs are obtained from the input variable which contains the
%   handles of the graphic objects where the values are entered.  
%   Called by cycle_calc.m, air_standard.m, real_air.m, complete_comb.m,
%   eq_comb.m
%
%   KMF     April 27/05 Rev 1
%


global input option eng_p
%Parameter setup

    %Set parameters required for all compression/expansion processes
        Tatm = str2double(get(input(1,2),'String'));
        Patm = str2double(get(input(2,2),'String'));
        Tinit = str2double(get(input(6,2),'String'));
        if option(4) == 0   %No intake throttling
            Pinit = Patm;
        else    %Intake throttling
            Pinit = str2double(get(input(7,2),'String'));
        end
        M = 28.96;
        vinit = 8.314/M*Tinit/Pinit; 
        rc = str2double(get(input(3,2),'String'));
        step = 50;
        R = eng_p(5);  %con rod to crank ratio
    
   if option(2) == 1 | option(2) == 2 | option(2) == 4     
        %Standard or Atkinson process
            
            %Initialize crank angle at beginning and end of compression
            thetainit = -pi;
            thetafinal = 0;
    elseif option(2) == 3
        %Miller process
            
            %Initialize crank angle at beginning and end of compression
            thetainit = str2double(get(input(5,2),'String'))*pi/180;
            thetafinal = 0;
   end     
        
   if option(2) == 1 | option(2) == 3 | option(2) == 4
    %Standard and Miller cycles
        re = rc;    %Expansion ratio = compression ratio
    elseif option(2) == 2   
    %Atkinson cycle
        re = str2double(get(input(4,2),'String'));
   end 
   
   if option(5) == 0
   %No exhaust back pressure
        Pfinal = str2double(get(input(2,2),'String'));
   else
   %Exhaust back pressure    
        Pfinal = str2double(get(input(17,2),'String'));
   end
   