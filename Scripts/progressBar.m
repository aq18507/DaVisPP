%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240327                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240327: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function progressBar(iteration,total_iterations,settings)
    % Check whether additional seetings are present
    if ~exist("settings","var")
        indentation = 0;
    elseif ~isfield(settings,"indentation")
        indentation = 0;
    else
        indentation = settings.indentation;
    end
    % Main function
    if iteration == 0
        fprintf('%s Progress:   0%% [%s]',repmat(' ',1,indentation),repmat('-', 1, 50));
    else
        % Update progress bar
        progress = iteration/total_iterations;
        num_symbols = floor(progress * 50);
        remaining_symbols = 50 - num_symbols;
        
        % Clear previously printed progress bar
        fprintf(repmat('\b', 1, 57));
        
        % Print updated progress bar
        fprintf('%3d%% [%s%s]', ...
            round(progress*100), ...
            repmat('#', 1, num_symbols), repmat('-', 1, remaining_symbols));
        num_symbols = floor(progress * 50);
        remaining_symbols = 50 - num_symbols;
        
        % Clear previously printed progress bar
        fprintf(repmat('\b', 1, 57));
        
        % Print updated progress bar
        fprintf('%3d%% [%s%s]', ...
            round(progress*100), ...
            repmat('#', 1, num_symbols), repmat('-', 1, remaining_symbols));
    end
end