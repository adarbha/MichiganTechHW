function F = vol2theta(theta,v,vclearance,rc,R,z3,z4)

%   This function is used to convert a specific volume to a crank angle.
%
%   Called by brackroot.m
%
%   KMF     April 27/05 Rev 1
% 

    F= v-vclearance*(1+.5*(rc-1)*(R+1-cos(theta)-(R^2-(sin(theta)).^2).^.5));