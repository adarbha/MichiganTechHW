function z = minmod(x,y)

if (abs(x) < abs(y)) && x*y > 0
    z = x;
elseif (abs(x) > abs(y)) && x*y > 0
    z = y;
else
    z = 0;
end

end
