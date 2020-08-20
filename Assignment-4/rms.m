function [ out ] = rms( in )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sum = in.^2;
out = sqrt(mean(sum));
end

