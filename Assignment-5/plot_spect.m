function [ a ] = plot_spect( spect )
start_f = find(spect.f==0);
stop_f = find(spect.f==5000);
figure
plot(spect.f(start_f:stop_f),10*log10(spect.P(start_f:stop_f)))
xlabel('Frequency(Hz)')
ylabel('Gain(dB)')
grid
a=1;

end

