clc;
clear all;
P = [74.3
35.2
165.5
215.9
75.6
];
Vd = 8.9;
rpm = [1290
1200
1520
1650
1290
];
rps = rpm./60;
n = 2;
bmep_kPa = (P.*10^3)./(Vd.*rps);
bmep_bar = bmep_kPa/100;