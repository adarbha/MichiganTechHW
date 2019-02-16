function [ W ] = Work_cyc( P,V )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
vol_diff = diff(V);
% P_diff = zeros(length(vol_diff),1);
W = 0;
for i=1:(length(vol_diff)-1)
    P_diff(i) = (P(i+1)+P(i))/2;
    W = W + P_diff(i)*vol_diff(i);
end


end

