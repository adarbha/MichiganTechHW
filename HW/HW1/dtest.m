function [ f ] = dtest( u,x,t )
%   Detailed explanation goes here
f = 1+(t*cos(x-u*t));
end

