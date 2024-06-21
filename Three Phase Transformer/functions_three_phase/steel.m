function [P, mu] = steel(M, B, Kg)

% M400-50 Alloy 
if strcmp(M, 'M400_50')
    
    file_M400_50 = 'M400-50_data.xlsx';   % Set the path of the Excel file
    M400_50 = readtable(file_M400_50);

    % Extract the columns as separate cells
    H_M400_50 = M400_50{:, 1};           % Extract H
    B_M400_50 = M400_50{:, 2};           % Extract B
    Bmax_M400_50 = M400_50{1:18, 5};     % Extract Bmax
    Ploss_M400_50 = M400_50{1:18, 6};    % Extract Ploss

    % Find index in array B_max
    [~, index_p] = min(abs(Bmax_M400_50 - B)); 

    % Steel core power loss [W]
    Ploss = Ploss_M400_50(index_p); 

    % Find index in array B
    [~, index] = min(abs(B_M400_50 - B)); 

    % Permeability of steel from B/H [Wb/A]
    mu = B_M400_50(index) / H_M400_50(index); 
end

% M1000-100 Alloy 
if strcmp(M, 'M1000_100')
    file_M1000_100 = 'M1000-100_data.xlsx';   % Set the path of the Excel file
    M1000_100 = readtable(file_M1000_100);

    % Extract the columns as separate cells
    H_M1000_100 = M1000_100{:, 1};           % Extract H
    B_M1000_100 = M1000_100{:, 2};           % Extract B
    Bmax_M1000_100 = M1000_100{1:18, 5};     % Extract Bmax
    Ploss_M1000_100 = M1000_100{1:18, 6};    % Extract Ploss

    % Find index in array B_max
    [~, index_p] = min(abs(Bmax_M1000_100 - B)); 

    % Steel core power loss [W]
    Ploss = Ploss_M1000_100(index_p); 

    % Find index in array B
    [~, index] = min(abs(B_M1000_100 - B)); 

    % Permeability of steel from B/H [Wb/A]
    mu = B_M1000_100(index) / H_M1000_100(index); 
end

% Steel core power loss [W]
P_steel = Kg * Ploss; 

% Additional power loss in steel (empirically, due to airgap) [W]
P_add = 0.3 * P_steel;

% Total power loss in steel [W]
P = P_steel + P_add;

end
