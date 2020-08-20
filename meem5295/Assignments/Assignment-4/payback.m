clc;
clear all;

cost_gas_new = 3.5:0.5:12; %per gallon
int = 4; %cost of money per year
int_gas = 4; %interest rate of gas
miles = 12000; %miles driven per year

invested = 8000; %Cost of technology in USD
mpg_cruze = 28; %In the case of Cruze
mpg_volt = 76; %mpg enhancement factor due to new technology - variable
 
%Iterations for calculating pay-back

for i = 1:length(cost_gas_new)
    year = 1;
    return1 = 0;
    return_iter = 0;
    cost_gas = cost_gas_new(i);
    
    
    while return1 <= invested
        cost_gas = cost_gas*(1+int_gas*0.01);
        p_value = 1/((1+int*0.01)^year); %Cost of money
        gas_spend = (miles*year)*(1/mpg_cruze)*cost_gas; %Amount spent on gas per year if Cruze is used
        gas_spend_new = (miles*year)*(1/mpg_volt)*cost_gas; %Amount soent on gas per year if Volt is used
        return_iter = (gas_spend - gas_spend_new)*p_value;
        return1 = return1 + return_iter;
        deficit(year) = invested - return1;
        year = year+1;
    end
    
    pbp(i) = (year-1)+(deficit(year-2)/return_iter); %Payback
end

figure(1)
plot(cost_gas_new,pbp,cost_gas_new,pbp,'*')
title('Decrease in payback period with increasing fuel cost')
xlabel('Cost of gas per gallon')
ylabel('Payback period in years')
grid on