%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------------    Transformer Single Phase   ------------------ %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lowest cost per test for each material
% Sensitivity check to capacitive and inductive loads
% Percentage response to the voltage regulator
% Plots and considerations


%% Initialization
clc; clear; close all;


%% Specifications
Vp = 10*10^3;       % Primary voltage [V]
Vs = 400;           % Secondary voltage [V]
f = 50;             % Frequency [Hz]
Sn = 1100 * 10^3;   % Nominal apparent power [VA]


%% Optimal Solution
% Choose the experiment
disp('Choose the test for the core: (1) M400_50  (2) M1000_100\n');
disp('M400_50 - Copper');
disp('M400_50 - Aluminum');
disp('M1000_100 - Copper');
disp('M1000_100 - Aluminum');
file = input('Your choice: ');

switch file
    case 1
        load('Confs_M400-50_Copper.mat');
    case 2
        load('Confs_M400-50_Aluminum.mat');
    case 3
        load('Confs_M1000-100_Copper.mat');
    case 4
        load('Confs_M1000-100_Aluminum.mat');
    otherwise
        disp('Wrong selection')
end

% Estrae tutti i costi e trova il minimo
costs = cellfun(@(x) x.Costs.Total_Cost, Confs);       % Costs
[min_cost, index] = min(costs);

% Estrae parametri di interesse 
Z1p = Confs{1,index}.Electrical.Z1p;
Z2p = Confs{1,index}.Electrical.Z2p;
Zm = Confs{1,index}.Electrical.Zm;
P_steel = Confs{1,index}.Power_loss.Steel_loss;

% Effettua efficiency test per carichi capacitivi e induttivi
inductive = 1;    % Inductive load
capacitive = 0;    % Capacitive load

[eff_inductive, Volt_Reg_Ind] = efficiency_test(Vp, Sn, Z1p, Z2p, Zm, P_steel, inductive);
[eff_capacitive, Volt_Reg_Cap] = efficiency_test(Vp, Sn, Z1p, Z2p, Zm, P_steel, capacitive);


