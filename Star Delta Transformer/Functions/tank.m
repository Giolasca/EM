function [Vol, Sup] = tank(w_core, h_core, d_core, w1, w2, d)

% Total transformer height [m]
tot_height = h_core;

% Total transformer lenght [m]
tot_lenght = w_core + w1 + w2 + 3*d;

% Total transformer width [m]
tot_width = 2*w1 + 2*w2 + d_core + 6*d;

% Total volume of transformer [m^3]
Vol = tot_width * tot_lenght * tot_height; 

% Total surface area of ​​the box (Height, Length, Width)
C1 = tot_lenght * tot_height * 2;     % Lenght * Height [m^2]
C2 = tot_width * tot_height * 2;      % Width * Height [m^2]
C3 = tot_lenght * tot_width *2;       % Lenght * Width [m^2]
Sup = C1 + C2 + C3;

end