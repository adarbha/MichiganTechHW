%Demo done during Session 23 to illustrate
%the effects of first multiplying the data
%block by a tapered window -- this is
%compared to no windowing
%
%clf
clc
clear all
set(0,'defaultaxesfontsize',16);

% CASE 1: No windowing
Nw=32;
Ws1=2*pi*5/32;  Ws2=2*pi*12/32;
x=20*cos(Ws1*(0:Nw-1))+cos(Ws2*(0:Nw-1));
freqomega=linspace(-pi,pi,1024);
z=abs(fftshift(fft(x,1024)));
fmag=20*log10(abs(z));
fmag=fmag-max(fmag);
clf
plot(freqomega,fmag,'LineWidth',4);
axis([-pi pi -40 0]);
title('DTFT: Two Sines w Diverse Amps-No Windowing'),...
xlabel('Omega'), ylabel('Magnitude (dB)'), grid
hold on
plot([Ws1 Ws1],[-40 0],'m--','LineWidth',4)
plot([Ws2 Ws2],[-40 0],'m--','LineWidth',4)
hold off
pause

% CASE 2: Use of a tapered window (window can be selected below)
Nw=32;
%Nw=input('window length');
%Nfft=input('FFT length');
Nfft=1024;
woff=pi/Nw;
coff=(Nw-1)/2;
wrec=ones(1,Nw);				% rectangular window
wsin=cos(woff*((0:Nw-1)-coff));			% sine window
whan=.5*wrec+.5*cos(2*woff*((0:Nw-1)-coff));	% Hanning window
wham=.54*wrec+.46*cos(2*woff*((0:Nw-1)-coff));	% Hamming window
xw=x.*wham;					% CHOOSE WINDOW TYPE HERE
z=abs(fftshift(fft(xw,1024)));
fmag=20*log10(abs(z));
fmag=fmag-max(fmag);
clf
plot(freqomega,fmag,'LineWidth',3);
axis([-pi pi -60 0]);
title('DTFT: Two Sines w Diverse Amps- Windowing'),...
xlabel('Omega'), ylabel('Magnitude (dB)'), grid
hold on
plot([Ws1 Ws1],[-60 0],'m--','LineWidth',4)
plot([Ws2 Ws2],[-60 0],'m--','LineWidth',4)
hold off