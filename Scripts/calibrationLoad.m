%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240904                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240909: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [calibration,file] = calibrationLoad(file)
    % Start timing
    tic;
    % Indentation Setting
    settings.indentation = 20;
    % File config file name and path
    file_name = sprintf("%sDaVisPP_calibration_data.mat",file.path);
    project_path = sprintf("%s%s\\",file.project_path,file.project);
    % Logic to find pos-processed data file which contains the calibration
    % file.
    files = dir(project_path);
    isdir = [files.isdir];
    names = {files.name};
    names(isdir == 0) = [];

    idx = startsWith(names,"Processing_subset");
    if sum(idx) == 0
        error("The directory <%s> does not contain any postporcessed data", ...
            project_path);
    elseif sum(idx) > 1
        eror("The directory <%s> contains more than one one set of post-processed data." + ...
            "Use the variable file.subset to define the data set",project_path);
    else
        file.subset = string(names(idx));
    end

    calibration.path = sprintf("%s%s\\",project_path,file.subset);
    if ~exist(file_name,"file")
        % Print start function message
        fprintf("configurationLoad -> Loading configuration from Configuration.xml in <%s>:", ...
            calibration.path);
        % Complete path with the addition of the configuration file location
        calibration.path = sprintf("%sCalibration\\",calibration.path);
        % Calibration file name
        fileName = "Calibration.xml";
        path = calibration.path;
        path_fileName = fullfile(calibration.path, fileName);
    
        try
            xmlDoc = xmlread(path_fileName);
        catch
            error('Failed to read XML file: %s', path_fileName);
        end

        % Extract the root node (Calibration)
        calibration = xmlDoc.getDocumentElement;

        % Start by converting the root node into a structured array
        calibration = nodeToStruct(calibration);
        % Convert all numeric values to double
        calibration = convertToDouble(calibration);
        % Add file name and path to the struct
        calibration.path = path;
        calibration.fileName = fileName;

        fprintf(" DONE\n");
        
        % Save data
        fprintf('%s Saving data to <%s>:',repmat(' ',1,settings.indentation),file_name);
        save(file_name,"calibration");
        fprintf(" DONE\n");
    else
        % Print start function message
        fprintf("configurationLoad -> Loading configuration from Configuration.xml in <%s>:", ...
            file_name);
        load(file_name);
        fprintf(" DONE\n");
    end
   % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,settings.indentation),elapsed_time);

%% Functions
function nodeStruct = nodeToStruct(node)
    % Initialize structure for the node
    nodeStruct = struct();
    
    % Add attributes to the structure
    if node.hasAttributes
        attributes = node.getAttributes;
        for i = 0:attributes.getLength-1
            attr = attributes.item(i);
            % Convert attribute name and value into fields in the structure
            nodeStruct.(char(attr.getName)) = char(attr.getValue);
        end
    end

    % Add child nodes to the structure recursively
    childNodes = node.getChildNodes;
    for i = 0:childNodes.getLength-1
        child = childNodes.item(i);
        if child.getNodeType == child.ELEMENT_NODE  % Only process element nodes
            childName = char(child.getNodeName);
            
            % Recursively capture child data into a substructure
            childStruct = nodeToStruct(child);
            
            % Convert purely numeric strings to double
            childStruct = convertToDouble(childStruct);
            
            % Store the child structure in the current node's structure
            if isfield(nodeStruct, childName)
                % If the field already exists, convert it to a cell array to handle multiple nodes with the same name
                if ~iscell(nodeStruct.(childName))
                    nodeStruct.(childName) = {nodeStruct.(childName)};
                end
                nodeStruct.(childName){end+1} = childStruct;
            else
                nodeStruct.(childName) = childStruct;
            end
        elseif child.getNodeType == child.TEXT_NODE && ~isempty(strtrim(char(child.getNodeValue)))
            % If it's a text node, store the value
            nodeStruct.Text = strtrim(char(child.getNodeValue));
        end
    end
end
%% Function to convert string numeric values to double
function structWithDoubles = convertToDouble(nodeStruct)
    fields = fieldnames(nodeStruct);
    for i = 1:numel(fields)
        field = fields{i};
        value = nodeStruct.(field);
        % Check if the value is a string and can be converted to double
        if ischar(value)
            % Try converting to double
            numValue = str2double(value);
            if ~isnan(numValue) % Check if the conversion was successful
                nodeStruct.(field) = numValue; % Update with double value
            end
        elseif isstruct(value)
            % Recursively convert if it's a structure
            nodeStruct.(field) = convertToDouble(value);
        end
    end
    structWithDoubles = nodeStruct; % Return the updated structure
end
end