function [L12, X12, x] = mutual_inductance(d, k, h, w1, w2, N1, Sn, Vp, f)

% Vacuum permeability
mu_0 = 4*pi*1e-7; 

% Radius of the core [m]
R_c = d / 2;

% Radii of primary windings [m]
R1 = R_c + k;      % Inner radius primary winding
R2 = R1 + w1;      % Outer radius primary winding
Rm1 = R1 + w1/2;   % Midpoint radius primary winding

% Radii of secondary windings [m]
Rmg = R2 + k/2;       % Midpoint radius between windings
R3 = R2 + k;          % Inner radius secondary winding
R4 = R3 + w2;         % Outer radius secondary winding
Rm2 = R3 + w2/2;   % Midpoint radius secondary winding

% Correction factor
s = 0.32 * (R4 - R_c);

C = (Rm1*w1/3 + Rm2*w2/3 + Rmg*k + w1^2/12 - w2^2/12);

% Mutual inductances of the windings [H]
L12 = ((2*pi*(N1^2)*mu_0)/h)*C;

% Mutual reactances for the windings [Ohm]
X12 = 2 * pi * f * L12 * 10;

Zb1 = Vp^2/(Sn);

% Winding reactance for unit
x = (2*pi)^2*mu_0*f*Sn/((Vp/N1)^2*(h+s)) * C; 
 
end

