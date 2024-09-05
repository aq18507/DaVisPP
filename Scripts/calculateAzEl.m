function [azimuth, elevation] = calculateAzEl(alpha, beta, gamma)
    % Define the rotation matrices
    Rx = [1, 0, 0;
          0, cos(alpha), -sin(alpha);
          0, sin(alpha), cos(alpha)];

    Ry = [cos(beta), 0, sin(beta);
          0, 1, 0;
          -sin(beta), 0, cos(beta)];

    Rz = [cos(gamma), -sin(gamma), 0;
          sin(gamma), cos(gamma), 0;
          0, 0, 1];
      
    % Combine the rotation matrices
    R = Rz * Ry * Rx;
    
    % Extract the azimuth and elevation
    azimuth = atan2(R(2,1), R(1,1));    % Azimuth in radians
    elevation = asin(-R(3,1));          % Elevation in radians
end