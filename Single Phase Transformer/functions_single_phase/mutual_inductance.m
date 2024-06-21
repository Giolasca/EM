function [L12, X12] = mutual_inductance(d, k, h, w1, w2, N1, f)

% Vacuum permeability
mu_0 = 4*pi*1e-7;   

% Radius of the core [m]
R = d / 2;

% Radii of primary windings [m]
r11 = R + k;      % Inner radius primary winding
r12 = r11 + w1;     % Outer radius primary winding
r1m = r11 + w1/2;   % Midpoint radius primary winding

% Radii of secondary windings [m]
rmg = r12 + k/2;       % Midpoint radius between windings
r21 = r12 + k;    % Inner radius secondary winding
r22 = r21 + w2;     % Outer radius secondary winding
r2m = r22 + w2/2;   % Midpoint radius secondary winding

% Mutual inductances of the windings [H]
L12 = 2*pi*N1^2*mu_0/h * (r1m*w1/3 + r2m*w2/3 + rmg * k + w1^2/12 - w2^2/12);

% Mutual reactances for the windings [Ohm]
X12 = 2 * pi * f * L12;

end

