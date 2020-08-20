function [ x_b ] = wiebe(CA,CA0,CA90,m,a)

x_b = 1-exp(-a*((CA-CA0)/(CA90-CA0)).^m);


end

