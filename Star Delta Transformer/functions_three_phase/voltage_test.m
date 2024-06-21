function [VolReg] = voltage_test(Vps, Ipp, Z1p, Z2p)
   
    % Define the vector of power factors
    PF = linspace(0, 0.9, 19);
    
    % Calculate the new powers capacitive load
    for i = 1:length(PF)
        r = Ipp;                        % Module
        theta = acos(abs(PF(i)));       % Theta in degree
        theta_rad = deg2rad(theta);     % Theta in rad

        a = r * cos(theta_rad);    % Real part
        b = r * sin(theta_rad);    % Immaginary part

        I_rated = a - 1i*b;

        V1_power = I_rated * (Z1p + Z2p) + Vps*25;

        VolReg = (abs(V1_power) - Vps*25)/(Vps*25);

    end    

end