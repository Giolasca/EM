%% Initialization
close all; clear all; clc

%% Resistance measurements
R_rs = 11.4;
R_st = 11.4;
R_tr = 11.3;
R_ph_aver = 11.367;
R_a = 1.7;
n_ph = 3;
poles = 4;
%% No Load test
V1_noload = [408, 388.2, 373.2, 352.4, 337.4, 310, 282.5, 245, 214, 182.9, 160.5, 138.4, 102.1]/sqrt(3);
I1_noload = [1.7, 1.58, 1.5, 1.37, 1.3, 1.17, 1.04, 0.89, 0.78, 0.69, 0.63, 0.59, 0.59];
P1_noload = 10^3*[0.4, 0.38, 0.36, 0.33, 0.31, 0.28, 0.25, 0.23, 0.2, 0.18, 0.17, 0.16, 0.15] / sqrt(3);
Q1_noload = 10^3*[2.11, 1.85, 1.67, 1.46, 1.31, 1.09, 0.87, 0.64, 0.47, 0.34, 0.26, 0.19, 0.11] / sqrt(3);
N_noload = -[1473.6, 1473.6, 1473.6, 1470.3, 1470.3, 1470.3, 1470.3, 1466.96, 1465.3, 1460.2, 1456.9, 1450.3, 1423.6];
T_noload = [-0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, -0.30];

NoLoad_test = table(V1_noload', I1_noload', P1_noload', Q1_noload', N_noload', T_noload', ...
          'VariableNames', {'V1 [V]', 'I1 [A]', 'P1 [kW]', 'Q1 [VAr]', 'N [RPM]', 'T [Nm]'});

figure
plot(I1_noload, V1_noload)
xlabel('Current [A]')
ylabel('Voltage [V]')
grid on
title('No Load Characteristics')

% Parameter estimation from no-load test
Rc = mean(V1_noload.^2 ./ P1_noload);
Xm = mean(V1_noload.^2 ./ Q1_noload);

%% Locked Rotor Test
V1_locked = [108, 96.6, 86.1, 76.7, 67.4, 61.8, 46, 32.7];
I1_locked = [3.6, 3.2, 2.8, 2.5, 2.2, 2, 1.5, 1.1];
P1_locked = 10^3*[0.8, 0.6, 0.5, 0.4, 0.3, 0.25, 0.14, 0.07] / sqrt(3);
Q1_locked = 10^3*[0.9, 0.7, 0.5, 0.4, 0.34, 0.27, 0.15, 0.08] / sqrt(3);
T_locked = [-1.19, -0.91, -0.75, -0.6, -0.45, -0.38, -0.2, -0.08];

Locked_Test = table(V1_locked', I1_locked', P1_locked', Q1_locked', T_locked', ...
          'VariableNames', {'V1 [V]', 'I1 [A]', 'P1 [kW]', 'Q1 [VAr]', 'T [Nm]'});

X12 = mean(V1_locked.^2 ./ Q1_locked);
X1 = X12 / 2;
X2p = X12 / 2;

R12 = mean(V1_locked.^2 ./ P1_locked);
R1 = R_rs/2;
R2p = R12 - R1;


%% Computing the torque
Z1_eq = 1i*Xm*(R1 + 1i*X1) / (R1 + 1i*(X1 + Xm));
R1eq = real(Z1_eq);
X1eq = imag(Z1_eq);
V1_eq = (380/sqrt(3))*1i*Xm / (R1 + 1i*(X1 + Xm));

s_maxT = R2p /sqrt(R1eq^2 + (X1eq + X2p)^2);

Tmax = (poles/(2*2*pi*50)) * (0.5 * 3 * abs(V1_eq)^2) / (R1eq + sqrt(R1eq^2 + (X1eq + X2p)^2));

%% Plot the electromechanical torque

% Given data
V1_100_load = [415.7 415.3 412.9 414.9 414.5 414.5]; % V1 [V]
I1_100_load = [2.01 2.13 2.32 2.61 2.75 2.91]; % I1 [A]
P1_100_load = [0.29 0.64 0.94 1.26 1.37 1.56]; % P1 [W]
Q1_100_load = [1.37 1.37 1.35 1.35 1.35 1.42]; % Q1 [W]
N_100_load = [1470 1467 1462 1432 1409 1399]; % N [RPM]
T_100_load = -[0.46 2.83 4.54 6.42 7.02 8.05]; % T [Nm]
Va_100_load = [0 60 80 90 100 120]; % Va [V]
Ia_100_load = [0 0.08 0.12 0.12 0.13 0.16]; % Ia [A]
Vf_100_load = [18.4 71.7 92.5 110.4 115.5 123.8]; % Vf [V]

figure(1)
plot(N_100_load, T_100_load)
grid on