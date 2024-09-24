function perp_vector = perpendicularToSpline(pp, t_point)
    % perpendicularToSpline - Computes a perpendicular vector to the spline at a given point
    % 
    % Syntax: perp_vector = perpendicularToSpline(pp, t_point)
    % 
    % Inputs:
    %   pp - Structure containing piecewise polynomials for x, y, and z
    %   t_point - Parameter value where the perpendicular vector is calculated
    % 
    % Outputs:
    %   perp_vector - A vector perpendicular to the spline at the point corresponding to t_point

    % Calculate the first derivatives (tangent) of the spline
    pp_dx = fnder(pp.x);
    pp_dy = fnder(pp.y);
    pp_dz = fnder(pp.z);

    % Evaluate the derivatives at t_point to get the tangent vector
    tangent_x = ppval(pp_dx, t_point);
    tangent_y = ppval(pp_dy, t_point);
    tangent_z = ppval(pp_dz, t_point);
    
    tangent_vector = [tangent_x, tangent_y, tangent_z];
    
    % Ensure the tangent vector is not zero
    if norm(tangent_vector) == 0
        error('The tangent vector is zero at the given t_point. Unable to define a perpendicular.');
    end
    
    % Choose a random vector that is not parallel to the tangent
    % For simplicity, we'll choose [1, 0, 0] unless the tangent is aligned with it
    random_vector = [1, 0, 0];
    if abs(dot(tangent_vector, random_vector)) == norm(tangent_vector) * norm(random_vector)
        % If they are parallel, choose another vector, e.g., [0, 1, 0]
        random_vector = [0, 1, 0];
    end
    
    % Compute a vector perpendicular to the tangent by using the cross product
    perp_vector = cross(tangent_vector, random_vector);
    
    % Normalize the perpendicular vector
    perp_vector = perp_vector / norm(perp_vector);

    disp('Perpendicular vector calculated.');
end
