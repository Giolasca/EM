function [R, L] = winding(rho_cu, A_wire, l_wire, N, mu_steel)

% Resistance for primary winding [Ohm]
R = rho_cu * l_wire / A_wire;  

% Inductances for primary winding [H]
L = N^2 * A_wire * mu_steel;  

end