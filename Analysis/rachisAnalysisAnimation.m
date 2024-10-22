%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240927                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240927: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function rachisAnalysisAnimation(data,file)
    
    % Extract data points from the data.processed and the data.rachis_idx
    % matrices
    r = data.rachis_idx;
    
    gifFile = exportGifs(file.project);

    for k = 1:size(data.processed.x(r,:),2)

        if k > 1
            hold off;
        end
        
        % Plot the entire loading cycle
        xr = flip(data.processed.x(r,:)');
        yr = flip(data.processed.y(r,:)');
        zr = flip(data.processed.z(r,:)');
        plot3(xr, yr, zr,'Color','r');
        hold on
    
        xr = data.processed.x(r,:);
        yr = data.processed.y(r,:);
        zr = data.processed.z(r,:);
        
        % Plot initial points
        scatter3(xr(:,k),yr(:,k),zr(:,k),'filled','o','b');
        plot3(xr(:,k),yr(:,k),zr(:,k),'b');

        % set(gcf,'position',[x0,y0,width,height])
        box on;
        grid on;
        axis equal;

        obj = gcf;
        if k == 1
            exportgraphics(obj, gifFile);
        else
            exportgraphics(obj, gifFile, Append=true);
        end
    end
end