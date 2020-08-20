% hold on
% for g = 1:10
%     
%     plot(x(2:63),u(g,2:63))
% end
% title('x v/s u graph for different time steps')
% xlabel('x')
% ylabel('u')
% hold off

        
f = zeros(46,63);

f(1,1:63) = x(1:63);
for(p=2:46)
    for v = 1:63
        f(p,v) = x(v) + f(p-1,v)*0.2;
    end
end

for r = 1:10
    for s=1:63
        t1(r,s) = t(r);
    end
end

hold on
for g = 1:10
    plot3(f(2,2:63),t1(g,2:63),u(g,2:63))
end
title('x v/s u graph for different time steps')
xlabel('x')
ylabel('u')

hold off

