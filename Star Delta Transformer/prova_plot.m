%% Initialization
clc; clear; close all;

% Choose the experiment
disp('Choose the test of interest');
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

% Extract data from the structs inside the cell array
Bc = cellfun(@(x) x.Parameters.B_core, Confs);         % B_core
Jw = cellfun(@(x) x.Parameters.J_winding, Confs);      % J_winding
ki = cellfun(@(x) x.Parameters.K_insulation, Confs);   % K_insulation
hw = cellfun(@(x) x.Parameters.h_windings, Confs);     % H_winding
Costo = cellfun(@(x) x.Costs.Total_Cost, Confs);       % Costs

% Unique values of hw
hw_values = [0.8, 1, 1.2, 1.4, 1.6, 1.8];
tol = 1e-5; % Tolerance for floating-point comparison

% Cycle over hw values
for hw_fixed = hw_values
    % Extract configurations with hw fixed (using tolerance)
    mask = abs(hw - hw_fixed) < tol;
    Bc_fixed = Bc(mask);
    Jw_fixed = Jw(mask);
    ki_fixed = ki(mask);
    Costo_fixed = Costo(mask);

    % Check if there is data to plot
    if ~isempty(Bc_fixed)
        figure;

        % B_core - K_insulation
        [Bc_grid, ki_grid] = meshgrid(linspace(min(Bc_fixed), max(Bc_fixed), 50), ...
                                      linspace(min(ki_fixed), max(ki_fixed), 50));
        Costo_grid_BK = griddata(Bc_fixed, ki_fixed, Costo_fixed, Bc_grid, ki_grid, 'linear');
        if ~isempty(Costo_grid_BK) && isequal(size(Costo_grid_BK), size(Bc_grid))
            subplot(1, 3, 1);
            surf(Bc_grid, ki_grid, Costo_grid_BK);
            xlabel('$$B_{core}$$', 'Interpreter','latex');
            ylabel('$$K_{insulation}$$','Interpreter','latex');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (B-K)', hw_fixed));
        end

        % B_core - J_winding
        [Bc_grid, Jw_grid] = meshgrid(linspace(min(Bc_fixed), max(Bc_fixed), 50), ...
                                      linspace(min(Jw_fixed), max(Jw_fixed), 50));
        Costo_grid_BJ = griddata(Bc_fixed, Jw_fixed, Costo_fixed, Bc_grid, Jw_grid, 'linear');
        if ~isempty(Costo_grid_BJ) && isequal(size(Costo_grid_BJ), size(Bc_grid))
            subplot(1, 3, 2);
            surf(Bc_grid, Jw_grid, Costo_grid_BJ);
            xlabel('$$B_{core}$$','Interpreter','latex');
            ylabel('$$J_{winding}$$','Interpreter','latex');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (B-J)', hw_fixed));
        end

        % J_winding - K_insulation
        [Jw_grid, ki_grid] = meshgrid(linspace(min(Jw_fixed), max(Jw_fixed), 50), ...
                                      linspace(min(ki_fixed), max(ki_fixed), 50));
        Costo_grid_JK = griddata(Jw_fixed, ki_fixed, Costo_fixed, Jw_grid, ki_grid, 'linear');
        if ~isempty(Costo_grid_JK) && isequal(size(Costo_grid_JK), size(Jw_grid))
            subplot(1, 3, 3);
            surf(Jw_grid, ki_grid, Costo_grid_JK);
            xlabel('$$J_{winding}$$','Interpreter','latex');
            ylabel('$$K_{insulation}$$','Interpreter','latex');
            zlabel('Cost');
            title(sprintf('Surf plot - hw = %.1f (J-K)', hw_fixed));
        end
        
        % Find minimum cost and corresponding parameters
        [min_cost, min_index] = min(Costo_fixed);
        min_ki = ki_fixed(min_index);
        min_jw = Jw_fixed(min_index);
        min_bc = Bc_fixed(min_index);
        
        % Plot cost in vicinity of minimum
        figure;
        scatter3(ki_fixed, Jw_fixed, Bc_fixed, 50, Costo_fixed, 'filled');
        hold on;
        scatter3(min_ki, min_jw, min_bc, 200, min_cost, 'r', 'filled');
        xlabel('$$K_{insulation}$$', 'Interpreter','latex');
        ylabel('$$J_{winding}$$','Interpreter','latex');
        zlabel('$$B_{core}$$','Interpreter','latex');
        title(sprintf('Cost around minimum for hw = %.1f', hw_fixed));
        colorbar;
        hold off;
    end
end
