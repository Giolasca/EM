function [efficiency, delta_V_perc] = efficiency_test(V_p, S_n, Z_1p, Z_2p, Zm, P_steel, flag)
   
    % Define the vector of power factors
    PF = linspace(0.1, 0.9, 9);
    S = zeros(length(PF), 1);

    % Calculate the new powers
    for i = 1:length(PF)
        if flag
            S(i) = S_n * (PF(i) + 1i * sqrt(1 - PF(i)^2));
        else
            S(i) = S_n * (PF(i) - 1i * sqrt(1 - PF(i)^2));
        end
    end
    
    % P_out [W]
    Pout = real(S);

    % Close the circuit with resistive load
    RLp = V_p^2 ./ Pout;
    XLp = V_p^2 ./ imag(S);

    ZLp = (RLp .* 1i.*XLp) ./ (RLp + 1i.*XLp);

    % Primary current from equivalent circuit
    Zeq_power = Z_1p + ((Z_2p + ZLp)*Zm) ./ (Zm + Z_2p + ZLp);

    % Equivalent current referred primary [A]
    I1_power = V_p ./ Zeq_power;

    % Power [W]
    S1_power = V_p * conj(I1_power);

    % Active input power related to copper [W]
    Pcu = real(S1_power);

    % Input power [W]
    Pin =  Pout + P_steel + Pcu;

    % Efficiency
    efficiency = Pout ./ Pin;

    % Voltage regulation
    I_rated = S ./ V_p;
    V1_power = V_p + (Z_1p + Z_2p).*conj(I_rated);
    delta_V_perc = (real(V1_power) - V_p) / V_p;
end