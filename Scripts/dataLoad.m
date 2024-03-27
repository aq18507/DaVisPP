%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240318                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240318: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [data,file] = dataLoad(file)
    % Print start function message
    fprintf("dataLoad -> Loading data from the .csv files in <%s> to the data struct:\n",file.path);

    % Progress bar settings
    settings.indentation = 11;
    
    % Display initial progress bar    
    progressBar(0,file.num,settings);
    tic;  % Start timing

    for i = 1:file.num
        data.raw.(file.name(i)) = readtable(sprintf("%s%s",file.path,file.file_name(i)),...
            VariableNamingRule="modify");

        % Update progress bar
        progressBar(i,file.num,settings);
    end    

    % Display completion message
    fprintf('\n');
    
    % Save data
    name = "DaVisPP_data.mat";
    fprintf('%s Saving data to <%s%s>:',repmat(' ',1,settings.indentation),file.path,name);
    save(sprintf("%s%s",file.path,"DaVisPP_data.mat"),"data","file");
    fprintf(" DONE\n");
    
    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,settings.indentation),elapsed_time);
end