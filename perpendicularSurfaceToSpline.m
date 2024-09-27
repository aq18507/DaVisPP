function [surface_points] = perpendicularSurfaceToSpline(pp, t_point, radius, num_points)
    % perpendicularSurfaceToSpline - Creates a surface perpendicular to the spline at a given point
    % 
    % Syntax: surface_points = perpendicularSurfaceToSpline(pp, t_point, radius, num_points)
    % 
    % Inputs:
    %   pp - Structure containing piecewise polynomials for x, y, and z
    %   t_point - Parameter value where the surface is calculated
    %   radius - Radius of the perpendicular surface (e.g., for a circular surface)
    %   num_points - Number of points to generate for the circular surface
    % 
    % Outputs:
    %   surface_points - Nx3 matrix representing points on the perpendicular surface
    
    % Step 1: Calculate the tangent vector at t_point
    pp_dx = fnder(pp.x);
    pp_dy = fnder(pp.y);
    pp_dz = fnder(pp.z);

    tangent_x = ppval(pp_dx, t_point);
    tangent_y = ppval(pp_dy, t_point);
    tangent_z = ppval(pp_dz, t_point);
    
    tangent_vector = [tangent_x, tangent_y, tangent_z];
    
    % Normalize the tangent vector
    tangent_vector = tangent_vector / norm(tangent_vector);
    
    % Step 2: Find two vectors orthogonal to the tangent
    % Choose a random vector that is not parallel to the tangent
    random_vector = [1, 0, 0];
    if abs(dot(tangent_vector, random_vector)) == norm(tangent_vector)
        random_vector = [0, 1, 0];
    end
    
    % First perpendicular vector
    perp_vector1 = cross(tangent_vector, random_vector);
    perp_vector1 = perp_vector1 / norm(perp_vector1);  % Normalize
    
    % Second perpendicular vector
    perp_vector2 = cross(tangent_vector, perp_vector1);
    perp_vector2 = perp_vector2 / norm(perp_vector2);  % Normalize

    perp_vector3 = cross(perp_vector1, perp_vector2);
    perp_vector3 = perp_vector3 / norm(perp_vector3);  % Normalize

    perp_vector4 = cross(perp_vector2, perp_vector1);
    perp_vector4 = perp_vector4 / norm(perp_vector4);  % Normalize
    
    % Step 3: Generate the circular surface points
    theta = linspace(0, 2*pi, num_points);  % Angles for generating points on the surface
    surface_points = zeros(num_points, 3);  % Preallocate matrix for surface points
    
    % Evaluate the point on the spline at t_point
    x_point = ppval(pp.x, t_point);
    y_point = ppval(pp.y, t_point);
    z_point = ppval(pp.z, t_point);
    point_on_spline = [x_point, y_point, z_point];
    
    % Generate the circular surface by combining the two perpendicular vectors
    for i = 1:num_points
        surface_points(i, :) = point_on_spline + radius * (cos(theta(i)) * perp_vector1 + sin(theta(i)) * perp_vector2);
    end
    
    % Step 4: Plot the results
    % figure;
    
    % Plot the original 3D spline
    % t_fine = linspace(min(t_point - 1, t_point + 1), max(t_point + 1, t_point - 1), 100)
    t_fine = linspace(1,pp.x.breaks(end), 1000);
    x_fine = ppval(pp.x, t_fine);
    y_fine = ppval(pp.y, t_fine);
    z_fine = ppval(pp.z, t_fine);
    plot3(x_fine, y_fine, z_fine, 'LineWidth', 2, 'DisplayName', '3D Spline');
    hold on;

    % Plot the point on the spline
    plot3(point_on_spline(1), point_on_spline(2), point_on_spline(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Point on Spline');

    % Plot the surface points
    fill3(surface_points(:, 1), surface_points(:, 2), surface_points(:, 3), 'b', 'FaceAlpha', 0.3, 'DisplayName', 'Perpendicular Surface');


    % Plot Vectors 1 and 2
    quiver3(point_on_spline(1), point_on_spline(2), point_on_spline(3), ...
        perp_vector1(1), perp_vector1(2), perp_vector1(3), 1, 'LineWidth', 2, 'MaxHeadSize', 2, 'DisplayName', 'Perpendicular Vector #1');
    quiver3(point_on_spline(1), point_on_spline(2), point_on_spline(3), ...
        perp_vector2(1), perp_vector2(2), perp_vector2(3), 1, 'LineWidth', 2, 'MaxHeadSize', 2, 'DisplayName', 'Perpendicular Vector #2');
    quiver3(point_on_spline(1), point_on_spline(2), point_on_spline(3), ...
        perp_vector3(1), perp_vector3(2), perp_vector3(3), 1, 'LineWidth', 2, 'MaxHeadSize', 2, 'DisplayName', 'Perpendicular Vector #3');
    quiver3(point_on_spline(1), point_on_spline(2), point_on_spline(3), ...
        perp_vector4(1), perp_vector4(2), perp_vector4(3), 1, 'LineWidth', 2, 'MaxHeadSize', 2, 'DisplayName', 'Perpendicular Vector #4');

    legend;
    title('Perpendicular Surface to 3D Spline');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
    axis equal;
end
