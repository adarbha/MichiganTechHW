

function[res] = newton_raphson1(func,dfunc,oldx,x,t)

tol = 1e-5;
error =1;
iter = 1;
while(error > tol && iter <500)
    y = feval(func,oldx,x,t);
    ydash = feval(dfunc,oldx,x,t);
    newx = oldx - y/ydash;
    error = abs(newx-oldx);
    oldx = newx;
    iter = iter+1;
end

if(iter>500)
oldx = 0.1*randn(1);
    while(error > tol)
         y = feval(func,oldx,x,t);
         ydash = feval(dfunc,oldx,x,t);
         newx = oldx - y/ydash;
         error = abs(newx-oldx);
         oldx = newx;
    end
end

res = oldx;

end











    
   
    