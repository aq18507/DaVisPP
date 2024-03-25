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
    indentation = 11;

    % Define the total number of iterations
    total_iterations = file.num;
    
    % Display initial progress bar
    fprintf('%s Progress:  0%% [%s]',repmat(' ',1,indentation),repmat('-', 1, 50));
    tic;  % Start timing

    for i = 1:file.num
        data.raw.(file.name(i)) = readtable(sprintf("%s%s",file.path,file.file_name(i)),...
            VariableNamingRule="modify");

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
    name = "DaVisPP_data.mat";
    fprintf('%s Saving data to <%s%s>:',repmat(' ',1,indentation),file.path,name);
    save(sprintf("%s%s",file.path,"DaVisPP_data.mat"),"data","file");
    fprintf(" DONE\n");
    
    % Calculate elapsed time
    elapsed_time = toc;
    fprintf('%s Elapsed time: %.2f seconds\n',repmat(' ',1,indentation),elapsed_time);
end