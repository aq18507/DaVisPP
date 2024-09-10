fileName = "Calibration.xml";


% Use fullfile to create the full file path
xmlFileName = fullfile(calibration.path, fileName);

% Read and parse the XML file
xmlDoc = xmlread(xmlFileName);

% Extract the root node (Calibration)
calibration = xmlDoc.getDocumentElement;

% Recursive function to traverse and capture XML data in a structured array
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

% Start by converting the root node into a structured array
calibrationStruct = nodeToStruct(calibration);

% Display the structured array
disp(calibrationStruct);

% Optional: Save the structured array to a .mat file
save('calibrationData.mat', 'calibrationStruct');