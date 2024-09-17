%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240916                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240916: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function data = dataProcessor(file,analysis,data)
    % Start timing
    tic;  
    % Print start function message
    fprintf("dataProcessor -> Arranging data based on the data.index_matrix:");

    % Progress bar settings
    settings.indentation = 16;

    num_file = file.num;   num_row = size(data.index_matrix,1);
    data.processed.x = nan([num_row num_file]);
    data.processed.y = nan([num_row num_file]);
    data.processed.z = nan([num_row num_file]);
    data.processed.c = nan([num_row num_file]);

    data.rawData.x = nan([num_row num_file]);
    data.rawData.y = nan([num_row num_file]);
    data.rawData.z = nan([num_row num_file]);

    for i = 1:num_file
        index = data.index_matrix(:,1);
        index_local = data.index_matrix(:,i);

        name = file.name(i);

        x = data.raw.(name).x_mm_;     y = data.raw.(name).y_mm_;
        z = data.raw.(name).z_mm_;     c = data.raw.(name).(analysis.var);
    
        rawData.x = x;  rawData.y = y;  rawData.z = z;
    
        z_min_0 = min(z);     z = z - z_min_0;
        x_min_0 = min(x);     x = x - x_min_0;
        y_min_0 = min(y);     y = y - y_min_0;
    
        dx = data.raw.(name).X_displacement_mm_;
        dy = data.raw.(name).Y_displacement_mm_;
        dz = data.raw.(name).Z_displacement_mm_;
        
        if i > 1
            x = x + dx;
            y = y + dy;
            z = z + dz;
            
            isNaN = isnan(data.index_matrix(:,i));
            index(isNaN) = [];
            index_local(isNaN) = [];
            if size(index_local,1) ~= index_local(end)
                error("Data in the data.index_matrix does not conform in culumn %d." + ...
                    "The data must be arranged sequentially.",i);
            end

            % Save data
            data.processed.x(index,i) = x;
            data.processed.y(index,i) = y;
            data.processed.z(index,i) = z;
            data.processed.c(index,i) = c;

            data.rawData.x(index,i) = rawData.x;
            data.rawData.y(index,i) = rawData.y;
            data.rawData.z(index,i) = rawData.z;
        else
            % Save data
            data.processed.x(:,i) = x;
            data.processed.y(:,i) = y;
            data.processed.z(:,i) = z;
            data.processed.c(:,i) = c;

            data.rawData.x(:,i) = rawData.x;
            data.rawData.y(:,i) = rawData.y;
            data.rawData.z(:,i) = rawData.z;
        end
    end    
    fprintf(" DONE\n");

    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,settings.indentation),elapsed_time);
end