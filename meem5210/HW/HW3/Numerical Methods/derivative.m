function[ z ] = derivative(x,y)

m=1;
k=4;
f=1;
B=0.3*((m*k)^0.5);

z = (1/m)*(f-(B*y)-(k*x));

end
