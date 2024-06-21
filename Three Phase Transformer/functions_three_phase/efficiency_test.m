function [performance_table] = efficiency_test(Vpp, Vpl, S_n, Z_1p, Z_2p, Zm, P_steel)
   
    % Define the vector of power factors
    PF = linspace(-0.9, 0.9, 19);
    S = zeros(length(PF), 1);
    
    % Calculate the new powers
    for i = 1:length(PF)
        if (PF(i) >= 0)
            S(i) = S_n * (PF(i) + 1i * sqrt(1 - PF(i)^2));
        else
            S(i) = S_n * (abs(PF(i)) - 1i * sqrt(1 - abs(PF(i))^2));
        end
    end
    
    % P_out [W]
    Pout = real(S);

    % Close the circuit with resistive load
    RLp = 3*Vpp^2 ./ Pout;
    XLp = Vpp^2 ./ imag(S/3);

    % Total load impedence
    ZLp = RLp + 1i*XLp; 

    % Primary current from equivalent circuit
    Zeq_power = Z_1p + ((Z_2p + ZLp) .* Zm) ./ (Zm + Z_2p + ZLp);

    % Equivalent current referred to primary [A]
    I1_power = Vpp ./ Zeq_power;

    % Power [W]
    S1_power = Vpp .* conj(I1_power);

    % Active input power related to copper [W]
    Pcu = 3 * real(S1_power);

    % Input power [W]
    Pin = Pout + P_steel + Pcu;

    % Efficiency
    Efficiency = Pout ./ Pin;
        
    % Voltage regulation
    I_rated = S ./(3*Vpp);
    V1_power = Vpl + (Z_1p + Z_2p) .* conj(I_rated);
    Voltage_regulator = (abs(V1_power) - Vpl)*100/Vpl;
    
    % Create the table
    performance_table = table(PF', Efficiency, Voltage_regulator, S, ...
                             'VariableNames', {'Power_factor', 'Efficiency', 'Voltage_regulator', 'S'});

end
