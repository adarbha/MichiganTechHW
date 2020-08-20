function [ dQ ] = AHR( P,V,g_avg,CA_mean )

for i = 2:length(P)-1
    
  dtheta = CA_mean(i+1)-CA_mean(i-1);
  dQ(i) = 0.5*dtheta*(((g_avg(i)/(g_avg(i)-1))*P(i)*((V(i+1)-V(i-1))/dtheta)) + ((1/(g_avg(i)-1))*V(i)*((P(i+1)-P(i-1))/dtheta)));

end

