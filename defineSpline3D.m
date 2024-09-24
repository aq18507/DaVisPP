function pp = defineSpline3D(t, x, y, z)
    % defineSpline3D - Creates a cubic spline interpolation for 3D data points.
    % 
    % Syntax: pp = defineSpline3D(t, x, y, z)
    % 
    % Inputs:
    %   t - Parameter vector (typically the sequence of indices or another independent parameter)
    %   x - X-coordinates of data points
    %   y - Y-coordinates of data points
    %   z - Z-coordinates of data points
    % 
    % Outputs:
    %   pp - Structure containing the piecewise polynomials for x, y, and z

    % Check if input vectors are of the same size
    if length(t) ~= length(x) || length(t) ~= length(y) || length(t) ~= length(z)
        error('Input vectors t, x, y, and z must all have the same length.');
    end

    % Create splines for x, y, and z with respect to the parameter t
    pp.x = spline(t, x);
    pp.y = spline(t, y);
    pp.z = spline(t, z);
end
