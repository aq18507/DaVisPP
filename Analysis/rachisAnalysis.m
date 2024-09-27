%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240927                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240927: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function rachisAnalysis(data)
    
    % Extract data points from the data.processed and the data.rachis_idx
    % matrices
    r = data.rachis_idx;
    xr = data.processed.x(r,:);
    yr = data.processed.y(r,:);
    zr = data.processed.z(r,:);
    
    % Plot initial points
    scatter3(xr(:,1),yr(:,1),zr(:,1),'filled','o','g');
    hold on
    
    % Plot the entire loading cycle
    xr = flip(data.processed.x(r,:)');
    yr = flip(data.processed.y(r,:)');
    zr = flip(data.processed.z(r,:)');
    plot3(xr, yr, zr,'Color','r');

    axis equal;
end