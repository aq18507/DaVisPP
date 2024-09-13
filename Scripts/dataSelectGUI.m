%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240318                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.240910: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
function [fig] = dataSelectGUI(A,camera,u,v)
    close all;
    clear selectedPoints;
    
    fig = figure('Name', 'Data Selection GUI', 'NumberTitle', 'off');
    
    ax1 = axes;
    showimx2(A.Frames{camera}, ax1);
    axis(ax1, "equal");
    colormap(ax1, 'gray');
    
    hold on;
    
    % Overlay the projected 2D points onto the image
    title('Select Points then click [Finish Selection]')
    hScatter = plot(u, v, 'ro', 'MarkerSize', 5, 'LineWidth', 2,'Color','b');  % Plot 2D points
    
    % Create a button to finish selection
    uicontrol('Style', 'pushbutton', 'String', 'Finish Selection', ...
              'Position', [20 20 120 30], ...
              'Callback', @finish_selection_callback);

    % Create a button to close the GUI
    uicontrol('Style', 'pushbutton', 'String', 'Close', ...
              'Position', [150 20 100 30], ...
              'Callback', @(src, event) close(fig));

    % Enable brushing
    brush on;  % Turn on the brush tool

    % Function to handle point selection and save to the workspace
    function finish_selection_callback(~,~)
        % Get the brush selection
        selectedPoints = get(hScatter, 'BrushData');

        % Retrieve the selected points
        if any(selectedPoints)
            % Find the indices of selected points
            selectedIdx = find(selectedPoints);

            % Highlight selected points in green
            scatter(u(selectedIdx), v(selectedIdx), 80, 'g', 'filled');  % Highlight selected points

            % % Save the selected points to the workspace as and index array
            assignin('base', 'selectedIdx', selectedIdx);
        else
            disp('No points were selected!');
        end
        
        % Turn off brushing after selection
        brush off;
    end
end