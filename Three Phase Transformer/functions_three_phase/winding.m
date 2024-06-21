function [R, L, X] = winding(rho_cu, A1_wire, l1_wire, N1, mu_steel, f)

% Resistance for primary winding [Ohm]
R = rho_cu * l1_wire / A1_wire;  

% Inductances for primary winding [H]
L = N1^2 * A1_wire * mu_steel;  

% Reactances for primary winding [Ohm]
X = 2 * pi * f * L;  

end