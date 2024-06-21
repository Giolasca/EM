function [A, d, l, V] = geom_wire_secondary(I, J, N, d_core, w1)  

    % Cross-sectional area of wire [m^2]
    A = I / J;

    % Diameter of the wire [m]
    d = sqrt(4 * A / pi);
    
    % Length of wire [m]
    l = ceil(N * 2 * pi * (d_core/2 + w1));   

    % Volume of winding [m^3]
    V = A * l;
    
end