%(FFT)
 
%Author: Mathuranathan for http://www.gaussianwaves.com
 
%License - Creative Commons - cc-by-nc-sa 3.0
clc;
clear all;
close all;
 
 
observationTime=1.4; %Input : Observation time interval change it to 100 and 1.4
 
%and see the effect on FFT
 
Fx=7; %Frequency of the sinusoid
 
Fs=100; %Sampling Frequency
t=0:1/Fs:observationTime;
x=1*sin(2*pi*Fx*t);
plot(t,x)
title('SineWave - Frequency = 7Hz');
xlabel('Times (s)');ylabel('Amplitude');
 
%Perform FFT
 
NFFX=2.^(ceil(log(length(x))/log(2)));
FFTX=fft(x,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(x);
f1=(0:NumUniquePts-1)*Fs/NFFX;
 
figure;
stem(f1,MY,'k');
title('FFT of the sine wave');
axis([0 50 0 1]);
xlabel('Frequency');ylabel('Amplitude');