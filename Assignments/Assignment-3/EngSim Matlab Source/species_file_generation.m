
%   This script file will generate comma separated variable txt files with
%   the thermodynamic data for various species.  These files are much
%   faster to read than Excel files.  
%
%   KMF     April 27/05 Rev 1
%



air_thdata=xlsread('air.xls','N2','a5:a64');        %Temperature vector
air_thdata(:,2:3)=xlsread('air.xls','N2','d5:e64'); %N2 enthalpy, entropy
air_thdata(:,4)=xlsread('air.xls','O2','a5:a64');   %Temperature
air_thdata(:,5:6)=xlsread('air.xls','O2','d5:e64'); %O2 enthalpy, entropy

k = 1;
for j = 1:2
    air_data(j,2) = xlsread('air.xls',j+2,'c2');
    air_data(j,3) = xlsread('air.xls',j+2,'e2');
    air_data(j,4:7) = xlsread('air.xls',j+2,'g2:j2');
end
air_data(1,1)=1;
air_data(2,1)=3.773;
csvwrite('air_data.txt',air_data)
csvwrite('air_thdata.txt',air_thdata)

k = 1;
for j = 1:6
    prod_data(j,2) = xlsread('products.xls',j+2,'c2');
    prod_data(j,3) = xlsread('products.xls',j+2,'e2');
    prod_data(j,4:7) = xlsread('products.xls',j+2,'g2:j2');
    prod_thdata(:,k) = xlsread('products.xls',j+2,'a5:a64');
    prod_thdata(:,k+1) = xlsread('products.xls',j+2,'d5:d64');
    prod_thdata(:,k+2) = xlsread('products.xls',j+2,'e5:e64');
    k=k+3;
end

csvwrite('prod_thdata.txt',prod_thdata)
csvwrite('prod_data.txt',prod_data)


k = 1;
for j = 1:11
    eqprod_data(j,2) = xlsread('eq_products.xls',j+2,'c2');
    eqprod_data(j,3) = xlsread('eq_products.xls',j+2,'e2');
    eqprod_data(j,4:7) = xlsread('eq_products.xls',j+2,'g2:j2');
    eqprod_thdata(:,k) = xlsread('eq_products.xls',j+2,'a5:a64');
    eqprod_thdata(:,k+1) = xlsread('eq_products.xls',j+2,'d5:d64');
    eqprod_thdata(:,k+2) = xlsread('eq_products.xls',j+2,'e5:e64');
    k=k+3;
end

csvwrite('eqprod_thdata.txt',eqprod_thdata)
csvwrite('eqprod_data.txt',eqprod_data)





