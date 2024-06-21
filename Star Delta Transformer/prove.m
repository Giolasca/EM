clear all;
clc;

V1 = 10*10^3 / sqrt(3);

Z1 = 0.85 + 1i*14;
Z2 = 1.2 + 1i*14;
Z0 = 9*10^3 + 1i*1.5*10^3;

Sn = 1100*10^3 / 3;

PF = 0.9;
PL = 1;
Sn_rat = Sn * PL * (PF + 1i*sqrt(1 - PF^2));

RL = V1^2 / real(Sn_rat);
XL = V1^2 / imag(Sn_rat);

ZL = (RL * 1i*XL) / (RL + 1i*XL);

Zeq = Z1 + ((Z2 + ZL)*Z0) / (Z2 + ZL + Z0);

I1 = V1 / Zeq;
S1 = V1 * conj(I1);

Ea = V1 - I1 * Z1;
Im = Ea / Z0;

I2 = I1 - Im;
V2_prim = Ea - I2*Z2;

SL = V2_prim * conj(I2);
P_steel = 1000;

eta = real(V2_prim) * real(I2) * PF / (real(V2_prim) * real(I2) * PF + real(I2)^2*(real(Z1 + Z2)) + 4.382764905282990e+03);

% Voltage regulator
V1_prim = V1 + (Z1 + Z2)*(I2);
Delta_V_perc = (abs(V1_prim) - V1) / V1;