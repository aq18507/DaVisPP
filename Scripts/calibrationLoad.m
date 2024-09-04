%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240904                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240318: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function calibration = calibrationLoad(calibration)
    % Start timing
    tic;
    % Indentation Setting
    settings.indentation = 20;
    % Print start function message
    fprintf("configurationLoad -> Loading configuration from Configuration.xml in <%s>:", ...
        calibration.path);
    % Complete path with the addition of the configuration file location
    calibration.path = sprintf("%sProperties\\Calibration\\",calibration.path);
    % Calibration file name
    fileName = "Calibration.xml";
    fileName = sprintf("%s%s",calibration.path,fileName);

    try
        xmlDoc = xmlread(fileName);
    catch
        error('Failed to read XML file: %s', fileName);
    end
    
    % Get the root element <Calibration>
    calibrationNode = xmlDoc.getDocumentElement;
    
    % Extract CalibrationIdentifier attribute
    calibrationID = char(calibrationNode.getAttribute('CalibrationIdentifier'));
    
    % Get all <CoordinateMapper> nodes
    coordinateMappers = calibrationNode.getElementsByTagName('CoordinateMapper');

    imageNo = 0;
    
    % Loop through each CoordinateMapper node
    for k = 0:coordinateMappers.getLength-1
        mapperNode = coordinateMappers.item(k);
        
        % Extract the CameraIdentifier attribute
        cameraID = str2double(mapperNode.getAttribute('CameraIdentifier'));

        % Advance image numerator
        if cameraID == 1
            imageNo = imageNo + 1;
            Image = sprintf('Image_%d',imageNo);
        end
        
        Camera = sprintf('Camera_%d',cameraID);
        
        % Extract internal camera parameters
        internalParamsNode = mapperNode.getElementsByTagName('InternalCameraParameters').item(0);
        
        % Focal length [pixels]
        focalLengthNode = internalParamsNode.getElementsByTagName('FocalLengthPixel').item(0);
        focalLengthX = str2double(focalLengthNode.getAttribute('x'));
        focalLengthY = str2double(focalLengthNode.getAttribute('y'));

        value = {'focalLengthX'; 'focalLengthY'};
        data = [focalLengthX; focalLengthY];
        T = table(value,data);
        calibration.data.(Image).(Camera).FocalLengthPixel = T; 
        
        % Principal point [pixels]
        principalPointNode = internalParamsNode.getElementsByTagName('PrincipalPoint').item(0);
        principalPointX = str2double(principalPointNode.getAttribute('x'));
        principalPointY = str2double(principalPointNode.getAttribute('y'));
        
        value = {'principalPointX'; 'principalPointY'};
        data = [principalPointX; principalPointY];
        T = table(value,data);
        calibration.data.(Image).(Camera).PrincipalPoint = T; 

        % Extract external camera parameters
        externalParamsNode = mapperNode.getElementsByTagName('ExternalCameraParameters').item(0);
        
        % Translation [mm]
        translationNode = externalParamsNode.getElementsByTagName('TranslationMm').item(0);
        Tx = str2double(translationNode.getAttribute('Tx'));
        Ty = str2double(translationNode.getAttribute('Ty'));
        Tz = str2double(translationNode.getAttribute('Tz'));

        value = {'Tx'; 'Ty'; 'Tz'};
        data = [Tx; Ty; Tz];
        T = table(value,data);
        calibration.data.(Image).(Camera).TranslationMm = T; 
        
        % Rotation angles [radians]
        rotationNode = externalParamsNode.getElementsByTagName('RotationAngles').item(0);
        Rx = str2double(rotationNode.getAttribute('Rx'));
        Ry = str2double(rotationNode.getAttribute('Ry'));
        Rz = str2double(rotationNode.getAttribute('Rz'));

        value = {'Rx'; 'Ry'; 'Rz'};
        data = [Rx; Ry; Rz];
        T = table(value,data);
        calibration.data.(Image).(Camera).RotationAngles = T;
    end
    fprintf(" DONE\n");
    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,settings.indentation),elapsed_time);
end