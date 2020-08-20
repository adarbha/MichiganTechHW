result = [];
for i=1:length(t)
    t_temp = t(i);
    z_temp = z(i,:);
    result = [result;t_temp,(example_4_post(t_temp,z_temp))'];
end