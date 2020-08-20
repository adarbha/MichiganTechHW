%Stop-counter is hard-coded. Try coming up with a better solution
clc;
clear all;

%Creating geometry
h = 0.2;

x_geom1 = 0:h:30;
x_geom2 = 0:h:15;
y_geom1 = 0:h:10;
y_geom2 = 0:h:5;

phi = zeros(length(y_geom1),length(x_geom1));

%defining phi on boundary conditions

%Boundary conditions at 10cm

for j=1:length(x_geom1)
    if(j < ((max(x_geom2)/0.2)+1))
        phi((max(y_geom1)/0.2)+1,j) = 1;
    else
        phi((5/0.2)+1,j) = 1;
    end
end

phi(length(y_geom2):length(y_geom1),length(x_geom2)) = 1;

%Inlet Boundary conditions for 0 to 10cm

for i = 1:length(y_geom1)
    phi(i,1) = y_geom1(i)/10;
end

%Outlet boundary conditions for 0 to 5cm

for i = 1:length(y_geom2)
    phi(i,length(x_geom1)) = y_geom2(i)/5;
end

%Running the Gauss-Sidel Stencil

phi_new = phi;
stopPoint = zeros(length(y_geom1),length(x_geom1)); %stop calculating at a certain point flag
stopCounter = (25*74) + (149*24); %Counter on the iteration while loop
stopSum = 0;
error_point = 0.00001; %Error for convergence
w = 1.0; %Relaxation factor

iter = 1;


while(stopSum < stopCounter)
    for i1 = 2:(length(y_geom1)-1)
        if i1<26
            for j1 = 2:(length(x_geom1)-1)
                if stopPoint(i1,j1) == 0
                    phi_new(i1,j1) = 0.25*(phi_new(i1-1,j1)+phi_new(i1+1,j1)+phi_new(i1,j1-1)+phi_new(i1,j1+1));
                    error = (phi_new(i1,j1) - phi(i1,j1))*100/phi(i1,j1);
                    phi_new(i1,j1) = w*phi_new(i1,j1) + (1-w)*phi(i1,j1);
                    if error <= error_point
                        stopPoint(i1,j1) = 1;
                    end
                    phi(i1,j1) = phi_new(i1,j1);
                end %stopPoint
            end %for-loop
        else
            for j1 = 2:(length(x_geom2)-1)
                if stopPoint(i1,j1) == 0
                    phi_new(i1,j1) = 0.25*(phi_new(i1-1,j1)+phi_new(i1+1,j1)+phi_new(i1,j1-1)+phi_new(i1,j1+1));
                    error = (phi_new(i1,j1) - phi(i1,j1))*100/phi(i1,j1);
                    phi_new(i1,j1) = w*phi_new(i1,j1) + (1-w)*phi(i1,j1);
                    if error <= error_point
                        stopPoint(i1,j1) = 1;
                    end
                    phi(i1,j1) = phi_new(i1,j1);
                end
            end
        end
    end
 stopSum = sum(stopPoint(:));
 iter = iter+1
end

%Plots
contour(phi_new,30)
