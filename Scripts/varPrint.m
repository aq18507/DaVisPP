%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240318                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240318: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function varPrint(file,analysis)
    fprintf("* * * * * * * * * * * * *\n" + ...
            "*  Variables  Available *\n" + ...
            "* * * * * * * * * * * * *\n\n");
    for j = 1:size(analysis.variables,2)
        fprintf('%s\n',cell2mat(analysis.variables(j)));
    end
    fprintf("\n" + ...
            "* * * * * * * * * * *\n" + ...
            "*  Directory Stats  *\n" + ...
            "* * * * * * * * * * *\n\n");
    fprintf("There are a total of %0.f .csv files in the <%s> directory\n", ...
        size(file.name,1),file.path);
end