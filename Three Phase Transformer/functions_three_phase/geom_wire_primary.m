function [A, d, l, V] = geom_wire_primary(I, J, N, d_core)  

    % Cross-sectional area of wire [m^2]
    A = I / J;

    % Diameter of the wire [m]
    d = sqrt(4 * A / pi);
    
    % Length of wire [m]
    l = ceil(N * pi * d_core);   

    % Volume of winding [m^3]
    V = A * l;
    
end