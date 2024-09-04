function calibration = parseXML(filename)
    % parseCalibrationXML reads an XML file and extracts camera calibration data.
    %
    %   parseCalibrationXML(filename)
    %
    % Inputs:
    %   filename - A string specifying the path to the XML file.

    % Read the XML file into a DOM object
    try
        xmlDoc = xmlread(filename);
    catch
        error('Failed to read XML file: %s', filename);
    end
    
    % Get the root element <Calibration>
    calibrationNode = xmlDoc.getDocumentElement;
    
    % Extract CalibrationIdentifier attribute
    calibrationID = char(calibrationNode.getAttribute('CalibrationIdentifier'));
    fprintf('Calibration Identifier: %s\n', calibrationID);
    
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
            Image = sprintf("Image_%d",imageNo);
        end
        
        fprintf('\nCamera Identifier: %d\n', cameraID);
        Camera = sprintf("Camera_%d",cameraID);
        
        % Extract internal camera parameters
        internalParamsNode = mapperNode.getElementsByTagName('InternalCameraParameters').item(0);
        
        % Focal length
        focalLengthNode = internalParamsNode.getElementsByTagName('FocalLengthPixel').item(0);
        focalLengthX = str2double(focalLengthNode.getAttribute('x'));
        focalLengthY = str2double(focalLengthNode.getAttribute('y'));
        fprintf('  Focal Length (x, y): (%.2f, %.2f) pixels\n', focalLengthX, focalLengthY);
        value = {'focalLengthX'; 'focalLengthY'};
        data = [focalLengthX; focalLengthY];
        T = table(value,data)
        calibration.(Image).(Camera).FocalLengthPixel.T; 
        
        % Principal point
        principalPointNode = internalParamsNode.getElementsByTagName('PrincipalPoint').item(0);
        principalPointX = str2double(principalPointNode.getAttribute('x'));
        principalPointY = str2double(principalPointNode.getAttribute('y'));
        fprintf('  Principal Point (x, y): (%.2f, %.2f) pixels\n', principalPointX, principalPointY);
        
        % Extract external camera parameters
        externalParamsNode = mapperNode.getElementsByTagName('ExternalCameraParameters').item(0);
        
        % Translation
        translationNode = externalParamsNode.getElementsByTagName('TranslationMm').item(0);
        Tx = str2double(translationNode.getAttribute('Tx'));
        Ty = str2double(translationNode.getAttribute('Ty'));
        Tz = str2double(translationNode.getAttribute('Tz'));
        fprintf('  Translation (Tx, Ty, Tz): (%.2f, %.2f, %.2f) mm\n', Tx, Ty, Tz);
        
        % Rotation angles
        rotationNode = externalParamsNode.getElementsByTagName('RotationAngles').item(0);
        Rx = str2double(rotationNode.getAttribute('Rx'));
        Ry = str2double(rotationNode.getAttribute('Ry'));
        Rz = str2double(rotationNode.getAttribute('Rz'));
        fprintf('  Rotation Angles (Rx, Ry, Rz): (%.2f, %.2f, %.2f) radians\n', Rx, Ry, Rz);
    end
end