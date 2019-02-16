function y=nroot(x,t,u)
f = 1+sin(x-u*t)-u;
fp= -cos(x-u*t)*t-1;
y=u-f/fp;