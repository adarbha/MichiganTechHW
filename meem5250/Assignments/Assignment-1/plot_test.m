clc
clear all
t = 0:0.1:10;
pos = sin(4*t).*exp(-0.2*t);
vel = 4*cos(4*t).*exp(-0.2*t)-0.2*sin(4*t).*exp(-0.2*t);
h.fig = figure(1);
h.axs = axes;
h.lin(1) = line(t,pos,'Color','b');
h.lin(2) = line(t,vel,'Color','r');
grid;

h.axs;
get(h.lin(1),'Parent');
get(h.axs,'Children');
