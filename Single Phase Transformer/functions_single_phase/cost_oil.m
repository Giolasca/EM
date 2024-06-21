function [Cost_oil, Cost_tank] = cost_oil(Vol_tot, Vol_core, Vol_w1, Vol_w2, Sup, d, density)

% Cost contribution oil cooled transformer [€/kg]
cost_oil = 5;
density_oil = 883;  % Mobilect 39
tank_cost = 1;

% Total volume of oil tank [m^3]
Vol_oil = Vol_tot - Vol_core - Vol_w1 - Vol_w2;

% Weight of the oil [Kg]
Kg_oil = Vol_oil * density_oil;

% Cost Oil [€]
Cost_oil = Kg_oil * cost_oil;

% Cost tank [€]
Cost_tank = Sup * d * density * tank_cost;

end