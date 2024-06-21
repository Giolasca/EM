%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------------    Transformer Single Phase   ------------------ %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Comparison plot between optimal parameters  
% and cost through different experiments.

% 1) M400-50  &  Copper
% 2) M400-50  &  Aluminum
% 3) M1000-100  &  Copper
% 4) M1000-100  &  Aluminum

% Each 3D mesh plot represents the relationship between two parameters 
% (B_core - J_winding - K_insulation) and the cost with fixed h_winding


%% Initialization
%clc; clear; close all;

% Choose the experiment
disp('Choose the test of interest');
disp('1) M400_50 - Copper');
disp('2) M400_50 - Aluminum');
disp('3) M1000_100 - Copper');
disp('4) M1000_100 - Aluminum');
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

% Estrai i dati dalle struct all'interno della cell array
Bc = cellfun(@(x) x.Parameters.B_core, Confs);         % B_core
Jw = cellfun(@(x) x.Parameters.J_winding, Confs);      % J_winding
ki = cellfun(@(x) x.Parameters.K_insulation, Confs);   % K_insulation
hw = cellfun(@(x) x.Parameters.h_windings, Confs);     % H_winding
Costo = cellfun(@(x) x.Costs.Total_Cost, Confs);       % Costs

% Valori fissati di hw
hw_values = [0.8, 1, 1.2, 1.4, 1.6, 1.8];
tol = 1e-5; % Tolleranza per il confronto dei numeri in virgola mobile

% Ciclo sui valori di hw
for hw_fixed = hw_values
    % Estrai le configurazioni con hw fissato (utilizzando la tolleranza)
    mask = abs(hw - hw_fixed) < tol;
    Bc_fixed = Bc(mask);
    Jw_fixed = Jw(mask);
    ki_fixed = ki(mask);
    Costo_fixed = Costo(mask);

    % Controlla se ci sono dati da plottare
    if ~isempty(Bc_fixed)
        figure;

        % B_core - K_insulation
        [Bc_grid, ki_grid] = meshgrid(linspace(min(Bc_fixed), max(Bc_fixed), 50), ...
                                      linspace(min(ki_fixed), max(ki_fixed), 50));
        Costo_grid_BK = griddata(Bc_fixed, ki_fixed, Costo_fixed, Bc_grid, ki_grid, 'cubic');
        if ~isempty(Costo_grid_BK) && isequal(size(Costo_grid_BK), size(Bc_grid))
            subplot(1, 3, 1);
            surf(Bc_grid, ki_grid, Costo_grid_BK);
            xlabel('Bcore');
            ylabel('Kinsulation');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (B-K)', hw_fixed));
            rotate3d on; 
        end

        % B_core - J_winding
        [Bc_grid, Jw_grid] = meshgrid(linspace(min(Bc_fixed), max(Bc_fixed), 50), ...
                                      linspace(min(Jw_fixed), max(Jw_fixed), 50));
        Costo_grid_BJ = griddata(Bc_fixed, Jw_fixed, Costo_fixed, Bc_grid, Jw_grid, 'cubic');
        if ~isempty(Costo_grid_BJ) && isequal(size(Costo_grid_BJ), size(Bc_grid))
            subplot(1, 3, 2);
            surf(Bc_grid, Jw_grid, Costo_grid_BJ);
            xlabel('Bcore');
            ylabel('Jwinding');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (B-J)', hw_fixed));
            rotate3d on; 
        end

        % J_winding - K_insulation
        [Jw_grid, ki_grid] = meshgrid(linspace(min(Jw_fixed), max(Jw_fixed), 50), ...
                                      linspace(min(ki_fixed), max(ki_fixed), 50));
        Costo_grid_JK = griddata(Jw_fixed, ki_fixed, Costo_fixed, Jw_grid, ki_grid, 'cubic');
        if ~isempty(Costo_grid_JK) && isequal(size(Costo_grid_JK), size(Jw_grid))
            subplot(1, 3, 3);
            surf(Jw_grid, ki_grid, Costo_grid_JK);
            xlabel('Jwinding');
            ylabel('Kinsulation');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (J-K)', hw_fixed));
            rotate3d on; 
        end
    end
end





