function power=engine_a(omega,throttle)
%omega [rad/s] 
%power [Nm/s]
%torque [Nm]
pe=(.07024*omega+1.290e-4*omega.^2-2.369e-7*omega.^3)*1e3;
power=pe*throttle;
% torque=power./omega;