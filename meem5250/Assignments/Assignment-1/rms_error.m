function [ out ] = rms_error(exp_data,model_data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
out = sqrt(mean((exp_data-model_data).^2));

end

