function [ f ] = test( u,x,t )
%   Detailed explanation goes here
f = u-1-sin(x-(u*t));
end

