function [performance_table] = efficiency_test(Vpp, S_n, Z_1p, Z_2p, Zm, P_steel)

    % Define the vector of power factors
    PF_descending = linspace(0.9, 0, 10);
    PF_ascending = linspace(0.1, 0.9, 9);
    PF = [PF_descending, PF_ascending]; 
    S = zeros(length(PF), 1);

    % Initialize vectors for Efficiency and Voltage Regulator
    Efficiency = zeros(length(PF), 1);
    Voltage_regulator = zeros(length(PF), 1);

    % Calculate the new powers
    for i = 1:length(PF)
        
        % Define the apparent power S, considering leading and lagging PF
        if i <= length(PF_descending)
            S(i) = S_n * (PF(i) + 1i * sqrt(1 - PF(i)^2));   % lagging 
        else
            S(i) = S_n * (PF(i) - 1i * sqrt(1 - PF(i)^2));   % leading
        end
        
        % Close the circuit with load
        RLp = Vpp^2 / real(S(i));
        XLp = Vpp^2 / imag(S(i));

        % Total load impedance
        ZLp = (RLp * 1i*XLp) / (RLp + 1i*XLp);

        % Total equivalent impedance
        Zeq_power = Z_1p + (Z_2p + ZLp) .* Zm ./ (Zm + Z_2p + ZLp);

        % Equivalent current referred to primary [A]
        I1_power = Vpp ./ Zeq_power;

        % Electromotive force per phase
        Ea = Vpp - I1_power * Z_1p;

        % Magnetization current
        Im = Ea / Zm;

        % Effective secondary current per phase
        I2_power = I1_power - Im;

        % Secondary voltage referred to the primary
        V2_prim = Ea - I2_power * Z_2p;

        % Output power [W], Copper and Steel losses [W]
        Pout = abs(V2_prim) * abs(I2_power) * PF(i);
        Pcu = abs(I1_power)^2 * real(Z_1p + Z_2p);
        Pin = Pout + P_steel + Pcu;

        % Efficiency
        Efficiency(i) = Pout / Pin;

        % Voltage regulator
        V1_prim = Vpp + (Z_1p + Z_2p) * I1_power;
        Voltage_regulator(i) = (abs(V1_prim) - Vpp)*100 / Vpp;
    end

    % Create the table
    performance_table = table(PF', Efficiency, Voltage_regulator, ...
                             'VariableNames', {'Power_factor', 'Efficiency', 'Voltage_regulator'});
end


