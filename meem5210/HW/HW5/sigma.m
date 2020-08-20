function z = sigma(alpha,dt,dx)

z = 0.5*(psi(alpha,0.1)) + (dt/dx)*(alpha^2);

end