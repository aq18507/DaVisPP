%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240912                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240912: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [data,selectedIdx] = dataSelect(rawData,calibration,file,data,settings)

    % Start timing
    tic;  

    % Print start function message
    fprintf("dataSelect -> Manually elect data:");

    % Progress bar settings
    settings.indentation = 13;

    % Define the Cammera
    camera = file.camera;
    
    % Sample 3D points in the world coordinate system (original data)
    X_world = rawData.x(:,1)';  % Transpose to ensure it's a column vector
    Y_world = rawData.y(:,1)';  % Transpose to ensure it's a column vector
    Z_world = rawData.z(:,1)';  % Transpose to ensure it's a column vector
    
    % Extract relevant data group data from the calibration file
    PinholeParameters = ...
        calibration.CoordinateSystemsForEachView.CoordinateSystem.CoordinateMapper{1,...
        camera}.PinholeParameters;
    
    % Extract specific variables from the group file
    theta = PinholeParameters.ExternalCameraParameters.RotationAngles;
    t = PinholeParameters.ExternalCameraParameters.TranslationMm;
    FocalLength = PinholeParameters.InternalCameraParameters.FocalLengthPixel;
    PrincipalPoint = PinholeParameters.InternalCameraParameters.PrincipalPoint;
    CorrectedImageSize = PinholeParameters.CommonParameters.CorrectedImageSize;
    OriginalImageSize = PinholeParameters.CommonParameters.OriginalImageSize;
    pixel_size = PinholeParameters.InternalCameraParameters.SensorPixelSizeMm.Value;
    clear PinholeParameters;
    
    % Image Correction Factor
    if camera == 1
        cf_i = (OriginalImageSize.Height*OriginalImageSize.Width)/...
            (CorrectedImageSize.Height*CorrectedImageSize.Width);
    elseif camera == 2
        cf_i = 1;
    else
        error("The variable Camera must be defined and must either be 1 or 2");
    end

    % Focal length in millimeters (replace with your actual focal length)
    f_mm = FocalLength.x*cf_i;  % Focal length in mm
    
    % Convert focal length from mm to pixels
    f_x = f_mm / pixel_size;  % Focal length in pixels along the X-axis
    f_y = f_x;  % Focal length in pixels along the Y-axis (assuming square pixels)
    
    % Principal point (in pixels, typically the center of the image, replace with actual values)
    c_x = PrincipalPoint.x;  % Principal point X coordinate (image center)
    c_y = PrincipalPoint.y;  % Principal point Y coordinate (image center)
    
    % Skew (typically zero, unless you know otherwise)
    alpha = 0;  % Skew coefficient (usually 0)
    
    % Intrinsic camera matrix
    K = [f_x, alpha, c_x; 
         0,   f_y,  c_y;
         0,   0,    1];
    
    % Sample 3D points in the world coordinate system
    P_world = [X_world; Y_world; Z_world];  % 3xN matrix (N points)
    
    % Rotation matrices for each axis
    R_x = [1, 0, 0; 
           0, cos(theta.Rx), -sin(theta.Rx); 
           0, sin(theta.Rx), cos(theta.Rx)];
    
    R_y = [cos(theta.Ry), 0, sin(theta.Ry); 
           0, 1, 0; 
           -sin(theta.Ry), 0, cos(theta.Ry)];
    
    R_z = [cos(theta.Rz), -sin(theta.Rz), 0; 
           sin(theta.Rz), cos(theta.Rz), 0; 
           0, 0, 1];
    
    % Combined rotation matrix (Z-Y-X order)
    R = R_z * R_y * R_x;
    
    % Translation vector
    T = [t.Tx; t.Ty; t.Tz];  % Translation vector in the camera coordinate system
    
    % Apply the rotation to the 3D points
    P_rotated = R * P_world;  % 3xN matrix (N points)
    
    % Flip the Z-axis for right-handed systems
    if camera == 1
        P_rotated(3, :) = -P_rotated(3, :);  % Negate the Z coordinates
    end
    
    % Apply translation by adding the translation vector element-wise
    P_transformed = P_rotated + T;  % 3xN matrix (N points)
    
    % Convert world points to homogeneous coordinates (add a row of 1s)
    P_transformed_hom = [P_transformed; ones(1, size(P_transformed, 2))];  % 4xN matrix
    
    % Project 3D world points onto 2D image plane
    P_image_hom = K * P_transformed_hom(1:3, :);  % 3xN matrix
    
    % Normalize homogeneous coordinates to get (u, v) in the image
    u = P_image_hom(1, :) ./ P_image_hom(3, :);  % X coordinate in pixels
    v = P_image_hom(2, :) ./ P_image_hom(3, :);  % Y coordinate in pixels
    image_path = sprintf('%s%s\\CreateTimeSeries\\B00001.im7', ...
        file.project_path,file.project);
    A = readimx(image_path);
    
    % Call the data select GUI
    clear selectedIdx fig;
    fig = dataSelectGUI(A,camera,u,v);
    
    % Pauses until the figure is closed
    uiwait(fig);
    clear fig;
    fprintf(" DONE\n");
    
    % Load data from workspace
    selectedIdx = evalin("caller","selectedIdx");
    
    % Save index array
    if isfield(data,"dataSelectOutput")
        data.(data.dataSelectOutput) = selectedIdx;
    else
        data.selectedIdx = selectedIdx;
    end

    % Saving Data
    settings.variable = data.dataSelectOutput;
    dataSave(file,settings,selectedIdx);

    % Remove unused data
    field = 'dataSelectOutput';
    data.dataSelectOutput = rmfield(data,field);
    evalin('base', ['clear ', 'selectedIdx']);

    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,settings.indentation),elapsed_time);
end