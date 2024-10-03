% Original vertices from fill3 (possibly collinear)
x = [1 2 3 4];
y = [5 6 7 8];
z = [9 10 11 12];

% Create a grid of points from the x and y data
[X, Y] = meshgrid(linspace(min(x), max(x), 10), linspace(min(y), max(y), 10));

% Define Z manually as a plane (since points may be collinear)
Z = X + Y;  % Example: Assume Z is a linear plane (this can be adjusted)

% Plot the surface
surf(X, Y, Z);


