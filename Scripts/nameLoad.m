%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240318                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240318: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [file] = nameLoad(file)
    fprintf("nameLoad -> Loading meta data from <%s> directory: ",file.path);
    file.name = strings(file.num,1);
    file.file_name = strings(file.num,1);
    for i = 1:file.num
        file.file_name(i) = convertCharsToStrings(file.meta(i).name);
    end
    file.name = erase(file.file_name,".csv");
    fprintf("DONE\n");
end