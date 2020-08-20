function [value, isterminal, direction] = events_brake(t,z)
value = (z(2)-0);
isterminal = 1;
direction = 0;
end