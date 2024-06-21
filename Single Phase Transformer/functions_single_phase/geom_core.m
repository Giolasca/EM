function [A, d] = geom_core(Vp, N1, f, B_core)  
    
    % Cross-sectional area of the core based on flux density [m^2]
    A_1 = Vp / (sqrt(2) * pi * N1 * f * B_core);

    % Cross-sectional area of the core considering 90% fill factor [m^2]
    A = A_1 * 100/90;
    
    % Diameter of the core from the cross-sectional area [m]
    d = sqrt(4 * A / pi);
    
end


