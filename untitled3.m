% Define parameter t and 3D data points
t = [1, 2, 3, 4, 5];
x = [1, 3, 5, 6, 8];
y = [2, 4, 1, 5, 7];
z = [0, 2, 3, 2, 1];

% Create the 3D spline
pp = defineSpline3D(t, x, y, z);

% Define the point on the spline where we want to create the surface
t_point = 2;  % For example, at t = 3

% Call the function to create a perpendicular surface with a given radius
radius = 0.5;
num_points = 100;
surface_points = perpendicularSurfaceToSpline(pp, t_point, radius, num_points);
