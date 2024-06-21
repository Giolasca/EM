%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------------    Star-Delta Transformer   -------------------- %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Optimized design of a three phase YD distribution transformer
% with nominal primary to secondary line to line voltages 10kV/400V,
% 50Hz with nominal apparent power 1100kVA.

% Efficiency > 85% with the 50% rated output power
% at unity power factor and rated output voltage.

% Efficiency > 95% with the 75% rated output power
% at unity power factor and rated output voltage.

% Efficiency > 92% with the 100% rated output power
% at unity power factor and rated output voltage.


%% Initialization
clc; clear; close all;

% Adds the 'functions' directory to the search path
addpath('Functions');


%% Constraints and Costants
mu_0 = 4*pi*1e-7;   % Vacuum permeability

k_thickness = 0.0005 * 2;   % Thickness of insulation layer [m]
d_core_wire = 0.01;         % Space between the windings and core [m]
air_gap = 0.1e-3;           % Air gap of insulation layer [m]

% The resistivity of copper or aluminum depends on the temperature
% conditions and purity of the copper used in the transformer

% Wire Material
density_copper = 8960;    % Density of copper kg/m³
rho_cu = 1.68e-8;         % Resistivity of copper wire (ohm*m)
density_aluminum = 2700;  % Density of aluminum kg/m³
rho_al = 2.82e-8;         % Resistivity of aluminum wire (ohm*m)

% Core Material
density_M400_50 = 77000;       % Density kg/m³
density_M1000_100 = 78000;     % Density kg/m³


%% Design choices

% Hypothetical thikness for the transformer box [m]
d_tank = 0.005;

% Choose the material
disp('Choose the material for the core: (1) M400_50  (2) M1000_100');
mat_core = input('Your choice: ');

switch mat_core
    case 1
        core_mat = 'M400_50';
        density_steel = density_M400_50;
        cost_steel = 12;
    case 2
        core_mat = 'M1000_100';
        density_steel = density_M1000_100;
        cost_steel = 4;
    otherwise
        disp('Wrong selection')
end

% Choose the material
disp('Choose the material for the wire: (1) Copper  (2) Aluminum');
mat_wire = input('Your choice: ');

switch mat_wire
    case 1
        density_wire = density_copper;
        rho_wire = rho_cu;
        cost_wire = 20;
    case 2
        density_wire = density_aluminum;
        rho_wire = rho_al;
        cost_wire = 4;
    otherwise
        disp('Wrong selection')
end


%% Transformer development

Vp_phase = 10*10^3/sqrt(3);    % Primary voltage phase star conf. [V]
Vs_phase = 400;                % Secondary voltage phase triangle conf. [V]

f = 50;              % Frequency [Hz]
Sn = 1100 * 10^3;    % Nominal apparent power [VA]
Sn_phase = Sn/3;     % Nominal apparent power phase [VA]


%% Optimization problem
% Configurations
Confs = {};

% Definition of ranges
B_core_range = 1.5:0.05:1.8;             % From 0.5 T to 1.8 T
J_winding_range = 18e5:0.25e5:20e5;     % From 2.5e5 A/m^2 to 20e5 A/m^2
K_insulation_range = 2.25:0.075:3;       % From 0.25 V to 3 V
h_windings_range = 1.25:0.05:1.55;         % From 0.8 m to 1.8 m

% Array of required efficiencies and corresponding load factors
Eff_required = [85, 95, 92] / 100;    % Conversion to decimal form
Load_factors = [0.5, 0.75, 1];        % Load factors 50%, 75%, 100%

% Iteration over every possible combination of B_core, J_winding, and K_insulation
for B_core = B_core_range
    for J_winding = J_winding_range
        for K_insulation = K_insulation_range

            a = Vp_phase/Vs_phase;    % Trasformation rate

            % Primary and secondary phase current [A]
            Ip_phase = Sn_phase/Vp_phase;
            Is_phase = Sn_phase/Vs_phase;

            % Number of primary and secondary coil
            N1 = ceil(Vp_phase/K_insulation);
            N2 = ceil(N1/a);

            % Cross-sectional area [m^2] and diameter [m] of core based on flux density
            [A_core, d_core] = geom_core(Vp_phase, N1, f, B_core);

            % Iteration over every possible winding height
            for h_windings = h_windings_range

                % Cross-sectional area [m^2], diameter [m], and length [m]
                % and winding width [m] of primary
                [A1_wire, l1_wire, Vol1_wire, w1] = geom_wire_primary(Ip_phase, J_winding, N1, d_core, k_thickness, h_windings);

                % Cross-sectional area [m^2], diameter [m], and length [m]
                % and winding width [m] of secondary
                [A2_wire, l2_wire, Vol2_wire, w2] = geom_wire_secondary(Is_phase, J_winding, N2, d_core, w1, k_thickness, h_windings);

                % Weight of the wires [Kg]
                Kg_wire1 = Vol1_wire * density_wire;
                Kg_wire2 = Vol2_wire * density_wire;

                % Height [m] and width [m] of the transformer
                h_core = h_windings + 2*d_core;
                w_core = w1 + w2 + 2*d_core + 3*d_core_wire;

                % Volume of the core [m^3] with 90% fill factor and core weight [kg]
                Vol_core = 2*A_core*w_core + A_core*(h_windings);

                % Magnetic circuit length [m]
                lenght_magnetic = 2*(w_core-d_core) + 2*(h_core-d_core);

                % Weight of the core [Kg]
                Kg_core = Vol_core * density_steel;


                %% Resistances and Reactances of the Core

                % Steel core power loss [W] and Permeability of steel from B/H [Wb/A]
                [Ploss_steel, mu_steel] = steel(core_mat, B_core, Kg_core);

                % Magnetization resistance R0 [Ohm]
                R0 = Vp_phase^2 / (Ploss_steel);

                % Magnetizing Reactance X0 [Ohm]
                X0 = 2 * pi * f * (N1^2) * (mu_steel * A_core / lenght_magnetic);

                % Core impedance (R0 || X0) [Ohm]
                Zm = (R0 * 1i * X0) / (R0 + 1i * X0);

                % Magnetizzation current [A]
                Im = Vp_phase/Zm;


                %% Resistances and Reactances of the Windings

                % Resistance for primary and secondary winding [Ohm]
                R1p = rho_wire * l1_wire / A1_wire;
                R2s = rho_wire * l2_wire / A2_wire;

                % Overall inductance [H]
                [L12, X12, x] = mutual_inductance(d_core, d_core_wire, h_windings, w1, w2, N1, Sn_phase, Vp_phase, f);

                % Check accetable winding reactance
                if x >= 0.5
                    % If it exceeds, this configuration does not meet the requirement
                    continue; % Exclude this configuration
                end

                % Resistance of primary and secondary windings [Ohm]
                R1s = R1p / a^2;      % Resistance of primary winding referred to secondary
                R2p = R2s * a^2;      % Resistance of secondary winding referred to primary

                % Reactance of primary and secondary windings [Ohm]
                X1p = X12 / 2;        % Reactance of primary winding
                X1s = X1p / a^2;      % Reactance of primary winding referred to secondary

                X2p = X12 / 2;        % Reactance of secondary winding
                X2s = X2p / a^2;      % Reactance of secondary winding referred to primary

                % Impedances of primary and secondary windings [Ohm]
                Z1p = R1p + 1i * X1p;   % Impedance of primary winding
                Z1s = Z1p/a^2;          % Impedance of primary winding referred to secondary

                Z2p = R2p + 1i * X2p;   % Impedance of secondary winding referred to primary
                Z2s = Z2p/a^2;          % Impedance of secondary winding


                %% Short-circuit current referred to the primary side

                % Total short-circuit impedance seen from the primary side
                Z_sc_primary = Z1p + Z2p;

                % Short-circuit current on the primary side
                I_sc_primary = Vp_phase / abs(Z_sc_primary);

                % Three times the primary nominal current
                Ip_3x = 3 * Ip_phase;

                % Check requirement in schort circuit current
                if I_sc_primary > Ip_3x
                    % If it exceeds, this configuration does not meet the requirement
                    continue; % Exclude this configuration
                end


                %% Costs

                % Cost core and wire [€]
                Cost_core = Kg_core * cost_steel;
                Cost_wire = (Kg_wire1 + Kg_wire2) * cost_wire;

                % Total volume of transformer [m^3]
                [Vol_tank, Sup_tank] = tank(w_core, h_core, d_core, w1, w2, d_core_wire);

                % Total cost of oil and tank [€]
                [Cost_oil, Cost_tank] = cost_oil(Vol_tank, Vol_core, Vol1_wire, Vol2_wire, Sup_tank, d_tank, density_steel);

                % Total cost of transformer [€]
                if (J_winding > 10e5)
                    Cost_tot = Cost_core + Cost_wire + Cost_tank + Cost_oil;
                else
                    Cost_tank = 0;
                    Cost_oil = 0;
                    Cost_tot = Cost_core + Cost_wire;
                end


                %% Efficiency test

                % Clear array vector of eta
                eta = zeros(1,3);

                % Iteration over every requirements to satisfy
                for i = 1:length(Load_factors)

                    % Rated power [VA]
                    Sn_rated = Sn_phase * Load_factors(i);

                    % Close the circuit with resistive load
                    RLp = Vp_phase^2/Sn_rated;

                    % Primary current from equivalent circuit
                    Zeq_eff_phase = Z1p + ((Z2p + RLp) * Zm)/((Z2p + RLp) + Zm);

                    % Equivalent current referred primary [A]
                    I1_eff_phase = Vp_phase/Zeq_eff_phase;

                    % Power [W]
                    S1_eff_phase = Vp_phase * conj(I1_eff_phase);
                    
                    % Electromotive force per phase
                    Ea = Vp_phase - I1_eff_phase * Z1p;
                    
                    % Magnetization current
                    Im = Ea / Zm;
    
                    % Effective secondary current per phase
                    I2_eff_phase = I1_eff_phase - Im;

                    % Secondary voltage referred to the primary
                    V2_prim = Ea - I2_eff_phase*Z2p;

                    % Output power [W], Copper ans Steel losses [W]
                    Pout = real(V2_prim) * real(I2_eff_phase) * Load_factors(i);
                    Pcu = real(I2_eff_phase)^2*(real(Z1p + Z2p));
                    Pin =  Pout + Ploss_steel + Pcu;

                    % Efficiency
                    eta(1,i) = Pout / Pin;

                end

                % If all requirements are met and if the cost has decreased, save this configuration
                if eta(1,1) >= Eff_required(1) && ...
                   eta(1,2) >= Eff_required(2) && ...
                   eta(1,3) >= Eff_required(3)
                    
                    % [Eff, voltage_regulation] = voltage_regulator(Zeqs, Vs_phase_tri, Sn, Ploss_steel);
                    [Performance] = efficiency_test(Vp_phase, Pout, Z1p, Z2p, Zm, Ploss_steel);
                    % [VolReg] = voltage_test(Vs_phase_tri, Ip_phase, Z1p, Z2p);

                    % Updating temporary arrays
                    paramsBest = [B_core, J_winding, K_insulation, h_windings];
                    geometryBest = [A1_wire, l1_wire, Vol1_wire, A2_wire, l2_wire, Vol2_wire, A_core, h_core, w_core, Vol_core];
                    electricalBest = [N1, N2, R1p, X1p, Z1p, R2p, X2p, Z2p, R0, X0, Zm];
                    powerBest = [Pout, Ploss_steel, Pcu];
                    costsBest = [Cost_core, Cost_wire, Cost_oil, Cost_tank, Cost_tot];

                    Confs{end+1} = save_conf(paramsBest, geometryBest, electricalBest, powerBest, costsBest, Performance);
                    % Confs{end+1} = save_conf(paramsBest, geometryBest, electricalBest, powerBest, costsBest);
                end
            end
        end
    end
end

% Save resullts in .mat file
if mat_core == 1 && mat_wire == 1
    save('Confs_M400-50_Copper', 'Confs');
elseif mat_core == 1 && mat_wire == 2
    save('Confs_M400-50_Aluminum', 'Confs');
elseif mat_core == 2 && mat_wire == 1
    save('Confs_M1000-100_Copper', 'Confs');
elseif mat_core == 2 && mat_wire == 2
    save('Confs_M1000-100_Aluminum_opt', 'Confs');
end
