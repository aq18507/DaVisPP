% Evaluate the position on the spline at t_point
x_point = ppval(pp.x, t_point);
y_point = ppval(pp.y, t_point);
z_point = ppval(pp.z, t_point);
point_on_spline = [x_point, y_point, z_point];

% Plot the original 3D spline
figure;
t_fine = linspace(min(t), max(t), 100);
x_fine = ppval(pp.x, t_fine);
y_fine = ppval(pp.y, t_fine);
z_fine = ppval(pp.z, t_fine);
plot3(x_fine, y_fine, z_fine, '-', 'LineWidth', 2, 'DisplayName', '3D Spline');
hold on;

% Plot the point on the spline
plot3(point_on_spline(1), point_on_spline(2), point_on_spline(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Point on Spline');

% Plot the perpendicular vector as an arrow
quiver3(point_on_spline(1), point_on_spline(2), point_on_spline(3), ...
        perp_vector(1), perp_vector(2), perp_vector(3), 1, 'LineWidth', 2, 'MaxHeadSize', 2, 'DisplayName', 'Perpendicular Vector');

legend;
title('Perpendicular Vector to 3D Spline');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
