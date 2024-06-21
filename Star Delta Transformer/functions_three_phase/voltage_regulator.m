function [efficiency, voltage_regulation] = voltage_regulator(Z, Vs_phase, S_n, Pfe)

    % Inizializzazione delle matrici dei risultati
    efficiency = [];
    voltage_regulation = [];
    pf_values = -1:0.1:1;

    for pf = pf_values
        % Calcolo della corrente nominale
        I_nominal = S_n/ (sqrt(3) * Vs_phase);

        % Calcolo delle perdite nel rame (Pcu) e delle perdite nel ferro (Pfe)
        Pcu = 3 * abs(I_nominal)^2 * real(Z);

        % Calcolo dell'efficienza
        Pout = sqrt(3) * Vs_phase * I_nominal * pf;
        eff = Pout / (Pout + Pcu + Pfe);
        efficiency = [efficiency; pf, eff];

        % Calcolo della regolazione del voltaggio
        delta_V = abs(Z) * I_nominal * (pf * cos(angle(Z)) + sin(angle(Z)));
        V_load = Vs_phase - delta_V;
        reg = (Vs_phase - V_load) / V_load;
        voltage_regulation = [voltage_regulation; pf, reg];
    end

    % Visualizzazione dei risultati
    disp('Efficiency (PF, Efficiency):');
    disp(efficiency);
    disp('Voltage Regulation (PF, Regulation):');
    disp(voltage_regulation);
end
