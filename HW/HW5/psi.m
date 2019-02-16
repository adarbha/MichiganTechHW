function z = psi(y,e)

if  abs(y) >= e
    z = abs(y);
else
    z = (y^2 + e^2)/(2*e);
end

end
    
    
    