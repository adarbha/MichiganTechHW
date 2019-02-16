function [ c ] = bisection( objFunc, l_limit, u_limit, tol,x,t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = feval(objFunc,l_limit,x,t);
b = feval(objFunc,u_limit,x,t);
error = 1000;

if(a*b > 0)
    u_limit = 0;
    while(a*b>0)
        u_limit = u_limit+randn(1)*0.1;
        b = feval(objFunc,u_limit,x,t);
    end
end


if(a==0)
        c = l_limit;
    else if(b==0)
            c = u_limit;
        else
            while(error > tol)
                c = (l_limit+u_limit)/2;
                newSol = feval(objFunc,c,x,t);
                if(newSol == 0)
                    u_limit = c;
                    l_limit = c;
                else if(newSol*a > 0)
                        l_limit = c;
                        a = feval(objFunc,l_limit,x,t);
                    else
                        u_limit = c;
                        b = feval(objFunc,u_limit,x,t);
                    end
                end
                error = abs(u_limit - l_limit);
            end
        end
   end


                
                
                
                            
                    
                            
                       
                    
                    
    




end

