%% Initialization
close all; clear all; clc

%% Resistance measurements
R_rs = 13.85;
R_st = 13.92;
R_tr = 13.89;
R_ph_aver = 13.89;
R_a = 1.6;

%% No Load test
V1_noload = [408, 388.2, 373.2, 352.4, 337.4, 310, 282.5, 245, 214, 182.9, 160.5, 138.4, 102.1];
I1_noload = [1.7, 1.58, 1.5, 1.37, 1.3, 1.17, 1.04, 0.89, 0.78, 0.69, 0.63, 0.59, 0.59];
P1_noload = [0.4, 0.38, 0.36, 0.33, 0.31, 0.28, 0.25, 0.23, 0.2, 0.18, 0.17, 0.16, 0.15] / sqrt(3);
Q1_noload = [2.11, 1.85, 1.67, 1.46, 1.31, 1.09, 0.87, 0.64, 0.47, 0.34, 0.26, 0.19, 0.11] / sqrt(3);
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

P_loss = P1_noload - abs(T_noload .* N_noload);

figure 
plot(I1_noload, P_loss)
xlabel('Current [A]')
ylabel('Power [W]')
grid on
title('Power Losses')

figure 
plot(V1_noload, Q1_noload)
xlabel('Voltage [V]')
ylabel('Reactive Power [kVAr]')
grid on
title('Reactive Power behavior')

%% Locked Rotor Test
V1_locked = [108, 96.6, 86.1, 76.7, 67.4, 61.8, 46, 32.7];
I1_locked = [3.6, 3.2, 2.8, 2.5, 2.2, 2, 1.5, 1.1];
P1_locked = [0.8, 0.6, 0.5, 0.4, 0.3, 0.25, 0.14, 0.07] / sqrt(3);
Q1_locked = [0.9, 0.7, 0.5, 0.4, 0.34, 0.27, 0.15, 0.08] / sqrt(3);
T_locked = [-1.19, -0.91, -0.75, -0.6, -0.45, -0.38, -0.2, -0.08];

Locked_Test = table(V1_locked', I1_locked', P1_locked', Q1_locked', T_locked', ...
          'VariableNames', {'V1 [V]', 'I1 [A]', 'P1 [kW]', 'Q1 [VAr]', 'T [Nm]'});

Z1_eq = 1i*Xm*(R1 + 1i*X1) / (R1 + 1i*(X1 + Xm));
R1eq = real(Z1_eq);
X1eq = imag(Z1_eq);
V1_eq = 220*1i*Xm / (R1 + 1i*(X1 + Xm));

Tmax = (4/(4*pi*50)) * (0.5 * 3 * abs(V1_eq)^2) / (R1eq + sqrt(R1eq^2 + (X1eq + X2p)^2));
s_maxT = R2 /sqrt(R1eq^2 + (X1eq + X2p)^2);

plot(I1_noload, V1_noload.^2 ./ Q1_noload)
grid on
xlabel('Current [A]', 'Interpreter','latex')
ylabel('Magnetization Inductance [$$\Omega$$]','Interpreter','latex')
title('$$X_m$$ as function of the stator current','Interpreter','latex')
xlim([0, max(I1_noload)*1.1]) % Set x-axis limits from 0 to the maximum current
ylim([0, max(V1_noload.^2 ./ Q1_noload)*1.1]) % Set y-axis limits from 0 to the maximum value of Xm

%% Derived parameters
R0 = mean(V1_noload.^2 ./ P1_noload);  % Total resistance of stator and rotor circuit (ohm)
Xm = mean(V1_noload.^2 ./ Q1_noload);  % Magnetizing reactance (ohm)

R12p = mean(V1_locked.^2 ./ P1_locked);
X12p = mean(V1_locked.^2 ./ Q1_locked);

R1 = R12 / 2;
R2 = R1; % At the start

plot(I1_locked, V1_locked.^2 ./ Q1_locked)
grid on
xlabel('Current [A]', 'Interpreter','latex')
ylabel('$$X_1 + X_2$$ [$$\Omega$$]','Interpreter','latex')
title('$$X_1 + X_2$$ as function of the stator current','Interpreter','latex')
xlim([0, max(I1_locked)*1.1]) % Set x-axis limits from 0 to the maximum current
ylim([0, max(V1_locked.^2 ./ Q1_locked)*1.1]) % Set y-axis limits from 0 to the maximum value of Xm

%% Save in a file .mat
save('Data_Group1.mat', 'R_rs', 'R_st', 'R_tr', 'R_ph_aver', 'R_a', ...
      'NoLoad_test', 'Locked_Test');
