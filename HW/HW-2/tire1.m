function mux_out=tire1(slipx_in)
% From Genta with slipy=0
nn=length(slipx_in);
mux_out=zeros(nn,1);
A=1.12;
C=0.625;
D=1;
n=0.6;
k=46;
d=5;
for i=1:nn
     slipx=slipx_in(i);
B=(k/(d))^(1/n);
if abs(slipx)>=0.9
    slipx=0.9*sign(slipx);
end
if slipx<=0
    slipx=-slipx;
    mux=-(A*(1-exp(-B*slipx))+C*slipx^2-D*slipx);
else
    mux=(A*(1-exp(-B*slipx))+C*slipx^2-D*slipx);
end
mux_out(i)=mux;
end

