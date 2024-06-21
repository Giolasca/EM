function [Cost_Fe, Cost_Cu] = cost_metals(M, Kg_core, kg_w1, kg_w2)

% M1000 and M400 steel cost [€/kg]
if strcmp(M, 'M400_50')
    Cost_steel = 12;
else
    Cost_steel = 4;
end

% Copper wire cost [€/kg]
Cu_cost = 20;

% Cost Steel [€]
Cost_Fe = Kg_core * Cost_steel;

% Cost Copper [€]
Cost_Cu = (kg_w1 + kg_w2) * Cu_cost;

end