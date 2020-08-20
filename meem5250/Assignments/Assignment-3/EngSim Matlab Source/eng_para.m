function eng_para

%   This function defines a dialog box for entering global engine
%   parameters which do not affect the cycle.
%
%   Parameters defining engine displacement, speed, and connecting
%   rod/crank throw ratio are entered in this box.  
%   Callback for eng_para button in Engine_sim.
%
%   KMF     April 27/05 Rev 1
%
%   KMF     Dec 30/06 Rev 2 - Added total displacement option 
%
%   JBB     Sept 24/09 Rev 3 - Update total displacement option to display
%                          displacement instead of stroke as default value.

global defaults eng_p


button = questdlg('Choose Total Displacement or Cylinder Measurements','Displacement','Total','Cylin','Total');

b1='Total';


if button == b1
    
    prompt(1) = {['Displacement (L):']};
    prompt(2) = {['Cylinders:']};
    prompt(3) = {['RPM:']};
    
    % Calculate the total displacement for the dialog box
    DefAns(1) = {num2str((pi*(defaults(31)/1000)^2/4*defaults(32)/1000)*defaults(33)*1000)};
    DefAns(2) = {num2str(defaults(33))};
    DefAns(3) = {num2str(defaults(34))};

else 
prompt(1) = {['Bore (mm):']};
prompt(2) = {['Stroke (mm):']};
prompt(3) = {['Cylinders:']};
prompt(4) = {['RPM:']};
prompt(5) = {['Con Rod/Crank Throw Ratio:']};

for i = 1:5
DefAns(i) = {num2str(defaults(30+i))};
end

end

eng_parameter = inputdlg(prompt,'Additional Engine Parameters',1,DefAns);

if button == b1 %Calculate bore and stroke based on displacement and nummber of cylinders

for i = 1:3         %Bore and Stroke entered
eng_pa(i) = str2double(eng_parameter(i));
end
    
eng_p(1)=(eng_pa(1)/1000/eng_pa(2)*4/pi)^(1/3)*1000;
eng_p(2)=eng_p(1);
eng_p(3)=eng_pa(2);
eng_p(4)=eng_pa(3);
eng_p(5)=3;

    
else
     
for i = 1:5         %Bore and Stroke entered
eng_p(i) = str2double(eng_parameter(i));
end
end

defaults(31:35)=eng_p;