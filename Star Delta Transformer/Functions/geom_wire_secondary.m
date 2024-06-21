function [A, l, V, w] = geom_wire_secondary(I, J, N, d_core, w_primary, k_thickness, h_windings)

    % Cross-sectional area of wire [m^2]
    A = I / J;

    % Diameter of the wire including insulation [m]
    d_wire = sqrt(4 * A / pi) + k_thickness;
    
    % Estimate the total number of layers
    N_overlaps = round((N * d_wire) / h_windings);
    
    % Adjusted length of wire considering the buildup of layers [m]
    l = 0;
    for layer = 1:N_overlaps
        current_diameter = d_core + 2*w_primary + (layer - 1) * d_wire * 2;
        l = l + (N / N_overlaps) * pi * current_diameter;
    end
    
    % Round up to the nearest meter
    l = round(l);
    
    % Volume of winding [m^3]
    V = A * l;
    
    % Total width of the windings
    w = N_overlaps * d_wire;

end
