function z = trapuneven(x,y)

%   This function will calculate an integral for the vectors x and y given
%   unevenly spaced data. 
%   USAGE: z = trapuneven(x,y)
%
%   Output: z = value of integral, used to calculate work out from
%   arbitrary heat release cycle.
%   Called by air_standard.m
%
%   KMF     April 27/05 Rev 1
n = length(x);

isum = 0;
for i = 1:n-1
    isum = isum + (y(i) + y(i+1))*(x(i+1)-x(i))/2;
end
z = isum;
