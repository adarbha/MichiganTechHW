function [ output_mat ] = fft_function( input_mat )
N = size(input_mat); %Block-size
ACF = 1/mean(flattopwin(N(1))); %Amplitude correction factor
fft_interim = fft(input_mat)./N(1);
output_mat = 2*ACF*((fft_interim(1:N(1)/2,:)));
end

