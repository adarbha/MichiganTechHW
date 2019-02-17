function [ output_mat ] = fft_function( input_mat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = size(input_mat);
ACF = 1/mean(hann(N(1)));
fft_interim = fft(input_mat)./N(1);
output_mat = 2*ACF*((fft_interim(1:N(1)/2,:)));
end

