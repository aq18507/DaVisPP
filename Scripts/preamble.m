%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240912                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240912: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function preamble()
    warning('off','MATLAB:table:ModifiedAndSavedVarnames');
    close all;
    addpath("Scripts\Polyfitn\");
    if ispc
        addpath("Scripts\readimx-v2.1.9-win\");
    elseif ismac
        addpath("Scripts\readimx-v2.1.8-osx\");
    else
        warning('Platform not officially supported');
    end
end