% Define parameter t and 3D data points
t = [1, 2, 3, 4, 5];
x = [1, 3, 5, 6, 8];
y = [2, 4, 1, 5, 7];
z = [0, 2, 3, 2, 1];

% Create the 3D spline
pp = defineSpline3D(t, x, y, z);

% Define the point on the spline where we want to find the perpendicular
t_point = 2; % For example, at t = 3

% Calculate the perpendicular vector at the given point
perp_vector = perpendicularToSpline(pp, t_point);

% Display the result
disp('Perpendicular vector:');
disp(perp_vector);
