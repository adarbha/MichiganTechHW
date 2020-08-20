function X = eq_composition(species_data,F,T,P,PSATM)
     
%   Routine for calculating composition of equilibrium mixtures.
%
%   Based on method developed by Olikara and Borman, SAE 750468.  Adapted
%   from Fortran code found in An Introduction to Combustion, Turns.
%   Species considered are H, O, N, CO, CO2, HO, H2O, H2, NO, N2, and O2.
%   Called by eq_solver.m, real_eq_comb.m
%
%   KMF     April 27/05 Rev 1
%    



global AN AM AL AK X
global AVM R H U DRT DHT DUT DRP DHP DUP DRF DHF DUF
global HREAC
global DXT DXP DXF
global HT CT SM CKP
global QN2 QCO2 QH2O IERQ QAR

AN = sum(species_data(:,1).*species_data(:,4));
AM = sum(species_data(:,1).*species_data(:,5));
AL = sum(species_data(:,1).*species_data(:,6));
AK = sum(species_data(:,1).*species_data(:,7));

nreactants = size(species_data,1);

CKP = csvread('Kp.txt');
QN2 = 3.773;
QCO2 = 0;
QH2O = 0;
QAR = 0;
PER(F,T,P,PSATM);
       
function EQMD(F,T,P,PSATM)
global AN AM AL AK X
global HREAC
global DXT DXP DXF
global HT CT SM CKP
global QN2 QCO2 QH2O IERQ QAR                
ZZ = 2.302585093;                                 
JF = 0;
if T <= 600 | T >= 5000
    errordlg('Combustion Temperature is outside range');
    return;
end
                
       PHI = F;                                                                                                   
       R0=(AN+0.25*AM-0.5*AL)/PHI;                                                
       R=R0*(1.+QCO2+0.5*QH2O)+0.5*AL;                                            
       R1=R0*QN2+0.5*AK;                                                          
       R2=R0*QAR;                                                                 
       R3=R0*QCO2+AN;                                                            
       R4=2.*R0*QH2O+AM;
       if R <= .5*R3
           errordlg('R<= .5*R3');
           return;
       end
                                               
       D1=R4/R3;                                                                  
       D2=2.0*R/R3;                                                               
       D3=2.0*R1/R3;                                                              
       D4=R2/R3;                                                                                                 
       
       %Interpolate Kp values using cubic spline
       
       SQP=sqrt(P/PSATM);                                                        
       NT=(T/100);                                                                  
       ANT=100.0/T;                                                             
       ANTSQ=ZZ*ANT/T;                                                            
       NTP=NT+1;
       T_Kp = 100*[1:(size(CKP,1))];
    for K = 1:size(CKP,2)                                                        
        AKC(K)=10.0^(spline(T_Kp,CKP(:,K),T));
        if K <= 3 
        AKC(K) = AKC(K)/SQP; end;
        if K >= 6
        AKC(K)=AKC(K)*SQP; end;
    end

KXG = 0;
if KXG ~= 1
    if JF ~= 0
        if abs(PHI - PHIPR) <= 1e-6 & abs(T/TPR - 1.0) <= 0.02 & abs(P/PPR-1.0) <= 0.05
            X(4) = X4PR;
            X(6) = X6PR;
            X(8) = X8PR;
            X(11) = X11PR;
        end
    end

        if PHI <= 1.0
        PAR=1.0/(R+R1+R2+0.25*R4);                                                 
        else
        PAR=1.0/(R1+R2+R3+0.5*R4);
        end
    FUN1=2.0*R3*AKC(7);                                                        
    FUN2=0.5*R4*AKC(6);                                                        
    FUN3=2.0/PAR;                                                              
    FUN4=2.0*R;                                                                
    OX=1.0;
    while OX >= 1.0E-37
    SQOX=sqrt(OX) ;                                                           
    FOX=(FUN1*SQOX+R3)/(1.0+AKC(7)*SQOX)+FUN2*SQOX/(1.0+AKC(6)*SQOX)...         
        +FUN3*OX-FUN4;                                                                                                             
    OX=0.1*OX;                                                                 
    end                                           
                                                           
IND=1;
while IND <=20
FOX=(FUN1*SQOX+R3)/(1.0+AKC(7)*SQOX)+FUN2*SQOX/(1.0+AKC(6)*SQOX)...         
     +FUN3*OX-FUN4;                                                            
DOX=0.25*FUN1/(SQOX*(1.0+AKC(7)*SQOX)^2)...                                 
    +0.5*FUN2/(SQOX*(1.0+AKC(6)*SQOX)^2)+FUN3;                            
RAT=FOX/DOX;                                                             
OX=OX-RAT;

        if (OX <= 0.)
            IERQ = 4;
            errordlg('Error 4');
            return;
        end
SQOX=sqrt(OX);
format long
       if(abs(RAT/OX) >= 1.0E-2)                                 
       IND=IND+1;
       else
       IND = 21;
       end
end
       X(4)=0.5*R4*PAR/(1.0+AKC(6)*SQOX);                                        
       X(6)=R3*PAR/(1.0+AKC(7)*SQOX);                                             
       X(8)=OX;                                                                   
       X(11)=R1*PAR;                                                              
end
IND=1;                                                                     
NCALL=0;
NCK = 1;
while NCALL ~= 1
    if NCK ~=0
     SQX4=sqrt(X(4));                                                          
     SQX8=sqrt(X(8));                                                          
     SQX11=sqrt(X(11));                                                        
     X(1)=AKC(1)*SQX4;                                                          
     X(2)=AKC(2)*SQX8;                                                          
     X(3)=AKC(3)*SQX11;                                                         
     X(5)=AKC(4)*SQX4*SQX8;                                                     
     X(7)=AKC(5)*SQX11*SQX8;                                                    
     X(9)=AKC(6)*X(4)*SQX8;                                                     
     X(10)=AKC(7)*X(6)*SQX8;
    end
     T14=0.5*AKC(1)/SQX4;                                                       
     T28=0.5*AKC(2)/SQX8;                                                       
     T311=0.5*AKC(3)/SQX11;                                                     
     T54=0.5*AKC(4)*SQX8/SQX4;                                                  
     T58=0.5*AKC(4)*SQX4/SQX8;                                                  
     T78=0.5*AKC(5)*SQX11/SQX8;                                                 
     T711=0.5*AKC(5)*SQX8/SQX11;                                                
     T94=AKC(6)*SQX8;                                                           
     T98=0.5*AKC(6)*X(4)/SQX8;                                                  
     T106=AKC(7)*SQX8;                                                          
     T108=0.5*AKC(7)*X(6)/SQX8;                                                 
     A(1,1)=T14+2.0+T54+2.0*T94;                                                
     A(1,2)=-D1*(1.0+T106);                                                     
     A(1,3)=(T58+2.0*T98)-D1*T108;                                              
     A(1,4)=0.0;                                                                
     A(2,1)=T54+T94;                                                            
     A(2,2)=(1.0+2.0*T106)-D2*(1.0+T106);                                       
     A(2,3)=(T28+T58+T78+2.0+T98+2.0*T108)-D2*T108;                             
     A(2,4)=T711;                                                               
     A(3,1)= 0.;                                                                
     A(3,2)=-D3*(1.0+T106);                                                     
     A(3,3)=T78-D3*T108;                                                        
     A(3,4)=T311+T711+2.0;                                                      
     A(4,1)=T14+1.0+T54+T94;                                                    
     A(4,2)=1.0+T106+D4*(1.0+T106);                                             
     A(4,3)=T28+T58+T78+1.0+T98+T108+D4*T108;                                   
     A(4,4)=T311+T711+1.0;                                                      
     if NCALL ~= 1
       B(1)  =-(X(1)+2.0*X(4)+X(5)+2.0*X(9))+D1*(X(6)+X(10));                     
       B(2)  =-(X(2)+X(5)+X(6)+X(7)+2.0*X(8)...                                     
             +X(9)+2.0*X(10))+D2*(X(6)+X(10));                                   
       B(3)  =-(X(3)+X(7)+2.0*X(11))+D3*(X(6)+X(10));                             
       B(4)  =-(X(1)+X(2)+X(3)+X(4)+X(5)+X(6)+X(7)+X(8)+X(9)+X(10)+X(11)...         
             +D4*(X(6)+X(10)))+1.0;                                              
[m,n]=size(B);
if n ~=1
B=B';
end
    B = A\B;
    NCK = 0;
    PREC = 10^-8;
    X(4)=X(4)+B(1);                                                            
    if(abs(B(1)/X(4) ) > PREC) 
        NCK=1;
    end

    X(6)=X(6)+B(2);                                                            
    if(abs(B(2)/X(6) ) > PREC) 
        NCK=1;
    end
    X(8)=X(8)+B(3);                                                            
    if(abs(B(3)/X(8) ) > PREC) 
        NCK=1;
    end
    X(11)=X(11)+B(4);                                                          
    if(abs(B(4)/X(11)) > PREC) 
        NCK=1;
    end
    if((X(4) <= 0.0) & (X(8) <= 0.0) & (X(11) <= 0.0))          
        IERQ=6
        errordlg('Error 6');
        return;
    end
        if(NCK ~= 0)                                                    
            if(IND >= 400)                                                    
                IERQ=7
                errordlg('Error 7 - Out of iterations');
                return;
            end
            IND=IND+1;                                                                 
        else
            if(X(6) < 0)
                IERQ = 6;
                errordlg('Error 6');
                return
            end

        IERQ = 0;
        JF=1;                                                                      
        PHIPR=PHI;                                                                 
        TPR=T;                                                                     
        PPR=P;                                                                     
        X4PR=X(4);                                                               
        X6PR=X(6);                                                                 
        X8PR=X(8);                                                                 
        X11PR=X(11);                                                               
        SQX4=sqrt(X(4));                                                          
        SQX8=sqrt(X(8));                                                          
        SQX11=sqrt(X(11));                                                        
        X(1)=AKC(1)*SQX4;                                                          
        X(2)=AKC(2)*SQX8;                                                          
        X(3)=AKC(3)*SQX11;                                                         
        X(5)=AKC(4)*SQX4*SQX8;                                                     
        X(7)=AKC(5)*SQX11*SQX8;                                                    
        X(9)=AKC(6)*X(4)*SQX8;                                                     
        X(10)=AKC(7)*X(6)*SQX8;                                                    
        X(13)=(X(6)+X(10))/R3;                                                     
        X(12)=R2*X(13);                                                                                                                        
        NCALL = 1;
        end
    end
end

NT_round = floor(NT);
NTP_round = NT_round + 1;

for K = 1:7
       DKC(K)=-NT_round*(NT_round+1)*ANTSQ*(CKP(NT_round,K)-CKP(NTP_round,K));                            
end
       DKC(1)= X(1)*DKC(1);                                                       
       DKC(2)= X(2)*DKC(2);                                                       
       DKC(3)= X(3)*DKC(3);                                                       
       DKC(4)= X(5)*DKC(4);                                                       
       DKC(5)= X(7)*DKC(5);                                                       
       DKC(6)= X(9)*DKC(6);                                                       
       DKC(7)=X(10)*DKC(7);                                                       
       PP2=.5/P;                                                                
       DC1P=-X(1)*PP2;                                                            
       DC2P=-X(2)*PP2;                                                            
       DC3P=-X(3)*PP2;                                                            
       DC9P=X(9)*PP2;                                                             
       DC10P=X(10)*PP2;                                                           
       D5AN=-R0*X(13)/PHI;                                                        
       DD4F=QAR*D5AN;                                                             
       C(1,1)=-(DKC(1)+DKC(4)+2.*DKC(6)-D1*DKC(7));                               
       C(2,1)=-(DKC(2)+DKC(4)+DKC(5)+DKC(6)+(2.-D2)*DKC(7));                      
       C(3,1)=-(DKC(3)+DKC(5)-D3*DKC(7));                                         
       C(4,1)=-(DKC(1)+DKC(2)+DKC(3)+DKC(4)+DKC(5)+DKC(6)+(1.+D4)*DKC(7));        
       C(1,2)=-(DC1P+2.*DC9P-D1*DC10P);                                           
       C(2,2)=-(DC2P+DC9P+(2.-D2)*DC10P);                                         
       C(3,2)=-(DC3P-D3*DC10P);                                                   
       C(4,2)=-(DC1P+DC2P+DC3P+DC9P+(1.+D4)*DC10P);                               
       C(1,3)=0.;                                                                 
       C(2,3)=2.*D5AN;                                                            
       C(3,3)=2.*QN2*D5AN;                                                        
       C(4,3)=-DD4F;                                                              
for K = 1:3
       KP1=K+1;                                                                   
       AMAX=abs(A(K,K));                                                         
       MAXMUM=K;                                                                  
    for I = KP1:4
        if (abs(A(I,K))) > AMAX
        AMAX=abs(A(I,K));                                                         
        MAXMUM=I;
        end
    end
        if AMAX <= 0                                           
        IERQ=8;
        errordlg('Error 8');
        return
        end
                                                                
        if MAXMUM ~= K
            for J = K:4
            TERM=A(K,J);                                                               
            A(K,J)=A(MAXMUM,J);                                                        
            A(MAXMUM,J)=TERM;
            end
            for J = 1:3
            TERM=C(K,J);                                                               
            C(K,J)=C(MAXMUM,J);                                                        
            C(MAXMUM,J)=TERM;                                                          
            end
        end
        for I = KP1:4
        TERM=A(I,K)/A(K,K);                                                        
            for J = KP1:4
               A(I,J)=A(I,J)-A(K,J)*TERM;
            end
            for J = 1:3
               C(I,J)=C(I,J)-C(K,J)*TERM;
            end
        end
end
if (abs(A(4,4))) <= 0 
        IERQ=8;
        errordlg('Error 8');
        return
end
for J = 1:3
       C(4,J)=C(4,J)/A(4,4);                                                      
       C(3,J)=(C(3,J)-A(3,4)*C(4,J))/A(3,3);                                      
       C(2,J)=(C(2,J)-A(2,3)*C(3,J)-A(2,4)*C(4,J))/A(2,2);                        
       C(1,J)=(C(1,J)-A(1,2)*C(2,J)-A(1,3)*C(3,J)-A(1,4)*C(4,J))/A(1,1);          
end
               
       DXT(4)=C(1,1);                                                             
       DXT(6)=C(2,1);                                                             
       DXT(8)=C(3,1);                                                             
       DXT(11)=C(4,1);                                                            
       DXP(4)=C(1,2);                                                             
       DXP(6)=C(2,2);                                                             
       DXP(8)=C(3,2);                                                             
       DXP(11)=C(4,2);                                                            
       DXF(4)=C(1,3);                                                             
       DXF(6)=C(2,3);                                                             
       DXF(8)=C(3,3);                                                             
       DXF(11)=C(4,3);                                                            
       DXT(1)=T14*DXT(4)+DKC(1);                                                  
       DXT(2)=T28*DXT(8)+DKC(2);                                                  
       DXT(3)=T311*DXT(11)+DKC(3);                                                
       DXT(5)=T54*DXT(4)+T58*DXT(8)+DKC(4);                                       
       DXT(7)=T78*DXT(8)+T711*DXT(11)+DKC(5);                                     
       DXT(9)=T94*DXT(4)+T98*DXT(8)+DKC(6);                                       
       DXT(10)=T106*DXT(6)+T108*DXT(8)+DKC(7);                                    
       DXT(12)=D4*(DXT(6)+DXT(10));                                               
       DXP(1)=T14*DXP(4)+DC1P;                                                   
       DXP(2)=T28*DXP(8)+DC2P;                                                    
       DXP(3)=T311*DXP(11)+DC3P;                                                  
       DXP(5)=T54*DXP(4)+T58*DXP(8);                                              
       DXP(7)=T78*DXP(8)+T711*DXP(11);                                            
       DXP(9)=T94*DXP(4)+T98*DXP(8)+DC9P;                                         
       DXP(10)=T106*DXP(6)+T108*DXP(8)+DC10P;                                     
       DXP(12)=D4*(DXP(6)+DXP(10));                                               
       DXF(1)=T14*DXF(4);                                                         
       DXF(2)=T28*DXF(8);                                                         
       DXF(3)=T311*DXF(11);                                                       
       DXF(5)=T54*DXF(4)+T58*DXF(8);                                              
       DXF(7)=T78*DXF(8)+T711*DXF(11);                                            
       DXF(9)=T94*DXF(4)+T98*DXF(8);                                              
       DXF(10)=T106*DXF(6)+T108*DXF(8);                                          
       DXF(12)=D4*(DXF(6)+DXF(10))+DD4F;
       if IERQ == 0
       return
       end
        
function PER(F,T,P,PSATM)
										
global AN AM AL AK X                                    
global AVM R H U DRT DHT DUT DRP DHP DUP DRF DHF DUF
global DXT DXP DXF                                    
global GRCAL CALTOJ RJOUL                                   
global HT CT SM CKP                      
global QN2 QAR QCO2 QH2O QAR                                         
global IERQ                                                      
                                                   
       IER=0;                                                                     
       IERQ=0;                                                                    
       KDER=1;                                                                    
 
if T <= 100 | T > 4000
    return;
end                  
EQMD(F,T,P,PSATM)                                                                 
                                                                    
