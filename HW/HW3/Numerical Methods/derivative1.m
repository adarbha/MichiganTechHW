function[ z ] = derivative1(x,v)

m=1;
k=4;
f=1;
B=2*(sqrt(m*k));

z = (1/m)*(f-(B*v)-(k*x));

end
