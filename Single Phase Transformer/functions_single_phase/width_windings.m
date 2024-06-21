function w = width_windings(N, d_wire, k_thickness, h_windings)  
    
    % Number of overlaps on the primary
    N_overlaps = round((N * (d_wire + k_thickness)) / h_windings);

    % Total final width of the primary winding [m]
    w = N_overlaps * (d_wire + k_thickness);
    
end