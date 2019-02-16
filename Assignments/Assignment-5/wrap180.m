function [ out_angle ] = wrap180( in_angle )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if 0 <=in_angle < 180
    out_angle = in_angle;
elseif 180 <= in_angle < 360
    out_angle = 360 - in_angle;
elseif 360 <= in_angle < 540
    out_angle = in_angle - 360;
else
    out_angle = abs(in_angle);

end

