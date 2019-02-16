omega = [1
1.05
1.1
1.15
1.2
1.21
1.22
1.23
1.25
1.5
1.75
1.95
];

iteration = [1378
1266
1164
1069
982
965
949
963
954
920
903
1033
];

hold on
plot(omega,iteration,'-r')
xlabel('Omega')
ylabel('Iteration number')
title('Optimal point for omega')
plot(1.75,903,'*')
grid
hold off