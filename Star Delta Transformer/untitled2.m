% Define the range of x values
x = linspace(0, 1, 1000); % Define x from 0 to 1 with 1000 points

% Define the frequency
f = 50;

% Calculate the sine values for the corresponding x values
y1 = sin(2*pi*f*x);
y2 = sin(2*pi*f*x + 2*pi/3);
y3 = sin(2*pi*f*x - 2*pi/3);

% Plot the sine function
plot(x, y1);
hold on
plot(x, y2);
plot(x, y3);
% Add labels and title
xlabel('x');
ylabel('sin(2\pi \cdot 50 \cdot x)');
title('Plot of sin(2\pi \cdot 50 \cdot x)');