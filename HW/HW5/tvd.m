% clear all;
% clc;

dx = 0.1;
x = 0:dx:2*pi;
C = 0.6;
dt = C*dx/2;
t = 0:dt:10;
u0 = 1;
A = 1;
len = length(x)+100;

u = ones(length(t),len);
u(1,1:length(x)) = u0 + A.*sin(x);

for n = 2:(length(t))
    %for i = 2:(length(x)-1)
    for i = 2:(len-1)
        
        duplus = u(n-1,i+1) - u(n-1,i);
        duminus = u(n-1,i) - u(n-1,i-1);
        if i == len-1
            duplus3ov2 = 0;
        else
            duplus3ov2 = u(n-1,i+1) - u(n-1,i+2);
        end
        if i == 2;
            duminus3ov2 = 0;
        else
            duminus3ov2 = u(n-1,i-1) - u(n-1,i-2);
        end
        
        %G's
        gi1 = minmod(duplus3ov2,duplus);
        gi = minmod(duplus,duminus);
        giminus1 = minmod(duminus,duminus3ov2);
        
        %alphas
        if duplus ~= 0
            alphaplus = (E(u(n-1,i+1)) - E(u(n-1,i)))/duplus;
        else
            alphaplus = 0.5*(u(n-1,i+1) + u(n-1,i));
        end
        
        if duminus ~=0
            alphaminus = (E(u(n-1,i)) - E(u(n-1,i-1)))/duminus;
        else 
            alphaminus = 0.5*(u(n-1,i) + u(n-1,i-1));
        end
        
        %betas
        if duplus == 0
            betaplus = 0;
        else
            betaplus = sigma(alphaplus,dt,dx)*(gi1-gi)/duplus;
        end
        
        if duminus == 0
            betaminus = 0;
        else
            betaminus = sigma(alphaminus,dt,dx)*(gi-giminus1)/duminus;
        end
        
        
        %phis
        phiplus = sigma(alphaplus,dt,dx)*(gi1 + gi) - psi((alphaplus + betaplus),0)*(duplus);
        phiminus = sigma(alphaminus,dt,dx)*(gi + giminus1) - psi((alphaminus + betaminus),0)*(duminus);
        
        %h's
        hhalfplus = 0.5*(E(u(n-1,i+1)) + E(u(n-1,i)) + phiplus);
        hhalfminus = 0.5*(E(u(n-1,i)) + E(u(n-1,i-1)) + phiminus);
        
        u(n,i) = u(n-1,i) - (dt/dx)*(hhalfplus - hhalfminus);
    end
end