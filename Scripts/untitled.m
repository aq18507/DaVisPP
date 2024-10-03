% Define the grid for (x, y) coordinates
[x, y] = meshgrid(-10:0.5:10, -10:0.5:10);

% Define the two surfaces z1 and z2 as functions of (x, y)
z1 = x.^2 + y.^2;   % Surface 1: Paraboloid
z2 = 2 * x.^2 + 2 * y.^2; % Surface 2: Another Paraboloid

% Define the point you want to check
x0 = 2;
y0 = 2;
z0 = 8;

% Find the value of z1 and z2 at the point (x0, y0)
z1_at_point = interp2(x, y, z1, x0, y0);
z2_at_point = interp2(x, y, z2, x0, y0);

% Check if z0 lies between z1 and z2
if z0 > min(z1_at_point, z2_at_point) && z0 < max(z1_at_point, z2_at_point)
    disp('The point lies between the two surfaces.');
else
    disp('The point does NOT lie between the two surfaces.');
end

% Plot the two surfaces
figure;
hold on;

% Plot surface 1
surf(x, y, z1, 'FaceAlpha', 0.5, 'EdgeColor', 'none'); % transparent surface 1
colormap jet; % Set colormap
colorbar; % Show colorbar

% Plot surface 2
surf(x, y, z2, 'FaceAlpha', 0.5, 'EdgeColor', 'none'); % transparent surface 2

% Plot the point
plot3(x0, y0, z0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% Label the axes
xlabel('X');
ylabel('Y');
zlabel('Z');

% Add a title
title('Two Surfaces and the Point Between Them');

% Add a legend
legend('Surface 1', 'Surface 2', 'Point');

% Set view angle for better visualization
view(45, 30);

hold off;
