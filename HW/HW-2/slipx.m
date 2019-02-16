function s=slipx(v,omega,r,vth)
n=length(v);
s=zeros(n,1);
for i=1:n
    v_temp=v(i);
    omega_temp=omega(i);
if abs(v_temp)>vth;
    s_temp=(omega_temp*r-v_temp)/abs(v_temp);
else
    s_temp=2*(omega_temp*r-v_temp)/(vth+v_temp^2/vth);
   
end
s(i)=s_temp;
end

