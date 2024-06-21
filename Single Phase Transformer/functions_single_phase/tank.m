function [Vol, Sup] = tank(w_core, h_core, d_core, w1, w2, k)

% Total transformer height [m]
tot_height = h_core;

% Total transformer lenght [m]
tot_lenght = w_core + w1 + w2 + 4*k;

% Total transformer width [m]
if w1 > w2
    tot_width = 2*w1 + d_core + 2*k;
else
    tot_width = 2*w2 + d_core + 2*k;
end

% Total volume of transformer [m^3]
Vol = tot_width * tot_lenght * tot_height; 

% Total surface area of ​​the box (Height, Length, Width)
C1 = tot_lenght * tot_height * 2;     % Lenght * Height [m^2]
C2 = tot_width * tot_height * 2;      % Width * Height [m^2]
C3 = tot_lenght * tot_width *2;       % Lenght * Width [m^2]
Sup = C1 + C2 + C3;

end