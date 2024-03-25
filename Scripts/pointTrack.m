%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240318                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240318: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [data] = pointTrack(file,data)

    % Print start function message
    fprintf("pointTrack -> Tracking pints across all files:\n")
    indentation = 13;
    
    % Define the total number of iterations
    total_iterations = file.num;
    
    % Display initial progress bar
    fprintf('%s Progress:  0%% [%s]',repmat(' ',1,indentation),repmat('-', 1, 50));
    tic;  % Start timing
    
    % Load reference data from the 1st (Reference) file
    tab = data.raw.(file.name(1));
    reference = [tab.x_mm_ tab.y_mm_ tab.z_mm_];    clear tab;
    reference_size = size(data.raw.(file.name(1)),1);
    index_matrix = nan([reference_size file.num]);
    index_matrix(:,1) = transpose(1:reference_size);
    
    for i = 2:file.num
        % Load Data from currentfile
        tab = data.raw.(file.name(i));
        dat = [tab.x_mm_ tab.y_mm_ tab.z_mm_];
        clear tab;
        for j = 1:size(data.raw.(file.name(i)),1)
    
            % Initialize variables to store the minimum distance and its 
            % corresponding index
            min_distance = Inf;
            matching_index = -1;
    
            % Calculate Euclidean distance between the current row of 
            % array1 and all rows of array2
            distances = sqrt(sum((reference - dat(j, :)).^2, 2));
            
            % Find the minimum distance
            [min_dist_row, min_dist_index] = min(distances);
            
            % If this minimum distance is smaller than the current minimum 
            % distance, update the minimum distance and its corresponding 
            % index
            if min_dist_row < min_distance
                matching_index = min_dist_index;
            end
            idx = matching_index;
            index_matrix(idx,i) = j;
        end
    
        % Update progress bar
        progress = i / total_iterations;
        num_symbols = floor(progress * 50);
        remaining_symbols = 50 - num_symbols;
        
        % Clear previously printed progress bar
        fprintf(repmat('\b', 1, 57));
        
        % Print updated progress bar
        fprintf('%3d%% [%s%s]', ...
            round(progress*100), ...
            repmat('#', 1, num_symbols), repmat('-', 1, remaining_symbols));
    end
    
    % Display completion message
    fprintf('\n');
    
    % Save data
    data.index_matrix = index_matrix;
    name = "DaVisPP_data.mat";
    save(sprintf("%s%s",file.path,name),"data","file");
    fprintf('%s Saving data to %s%s\n',repmat(' ',1,indentation),file.path,name);
    
    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,indentation),elapsed_time);
end