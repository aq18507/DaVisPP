% Define parameter t and 3D data points
t = [1, 2, 3, 4, 5];
x = [1, 3, 5, 6, 8];
y = [2, 4, 1, 5, 7];
z = [0, 2, 3, 2, 1];

% Call the function to create the 3D spline
pp = defineSpline3D(t, x, y, z);

% Evaluate the spline at a finer set of t values
t_fine = linspace(1, 5, 100);
x_fine = ppval(pp.x, t_fine);
y_fine = ppval(pp.y, t_fine);
z_fine = ppval(pp.z, t_fine);

% Plot the original 3D points and the spline
figure;
plot3(x, y, z, 'o', 'MarkerSize', 8, 'DisplayName', 'Data Points');
hold on;
plot3(x_fine, y_fine, z_fine, '-', 'LineWidth', 2, 'DisplayName', '3D Cubic Spline');
legend;
title('3D Cubic Spline Interpolation');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
