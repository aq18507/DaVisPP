%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240913                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240913: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% HELP:
% This function requires the following inputs to work:
% settings.indentation = 5;
% settings.variable = 'rachis_idx';
% settings.erase = 0; (OPTIONAL)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function dataSave(file,settings,DATA) %#ok<INUSD>
    % Convert DATA variable to the input variable
    eval(sprintf('%s = DATA;',settings.variable));
    clear DATA;
    
    name = sprintf("DaVisPP_%s.mat",settings.name);
    path = sprintf("%s%s",file.path,name);

    if isfield(settings,'erase') && settings.erase == 1
        delete(path);
        fprintf(['%s WARNING: using the "settings.erase" flag disables the' ...
            ' -append function\n'],repmat(' ',1,settings.indentation));
    end

    if exist(path,'file')
        fprintf('%s Saving data to <%s>:',repmat(' ',1,settings.indentation),path);
        save(path,settings.variable,'-append');
    else
        fprintf('%s Appending data to <%s>:',repmat(' ',1,settings.indentation),path);
        save(path,settings.variable);
    end
    fprintf(" DONE\n");
end