function f = radt(alpha,fz,mu,a,b)
fmax = mu*fz;
c = (a*fz)-(b*(fz^2));
alpha_max = fmax*3/c;
if alpha <= alpha_max
    ca = c*alpha;
    f= ca*(1-abs(ca/fmax)/3+((ca/fmax)^2)/27);
else
    f = fmax;
end

end
