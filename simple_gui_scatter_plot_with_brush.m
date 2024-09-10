function simple_gui_scatter_plot_with_brush()
    % Create sample data
    x = rand(1, 100) * 10;  % Random x values
    y = rand(1, 100) * 10;  % Random y values

    % Create figure
    fig = figure('Name', 'Data Selection GUI', 'NumberTitle', 'off');

    % Plot scatter data
    hScatter = scatter(x, y, 50, 'b', 'filled');  % Scatter plot with blue circles
    hold on;
    title('Select Data Points from the Scatter Plot');
    xlabel('X-axis');
    ylabel('Y-axis');

    % Create a button to finish selection
    uicontrol('Style', 'pushbutton', 'String', 'Finish Selection', ...
              'Position', [20 20 120 30], ...
              'Callback', @finish_selection_callback);

    % Create a button to close the GUI
    uicontrol('Style', 'pushbutton', 'String', 'Close', ...
              'Position', [150 20 100 30], ...
              'Callback', @(src, event) close(fig));

    % hold off;

    % Enable brushing
    brush on;  % Turn on the brush tool

    % Function to handle point selection and save to the workspace
    function finish_selection_callback(~, ~)
        % Get the brush selection
        selectedPoints = get(hScatter, 'BrushData');

        % Retrieve the selected points
        if any(selectedPoints)
            % Find the indices of selected points
            selectedIdx = find(selectedPoints);
            % Extract x and y values of selected points
            selectedX = x(selectedIdx);
            selectedY = y(selectedIdx);

            % Highlight selected points in green
            scatter(selectedX, selectedY, 80, 'g', 'filled');  % Highlight selected points

            % Save the selected points to the workspace
            assignin('base', 'selectedX', selectedX);
            assignin('base', 'selectedY', selectedY);
            assignin('base', 'selectedIdx', selectedIdx);

            disp('Selected points have been saved as variables "selectedX" and "selectedY" in the workspace.');
        else
            disp('No points were selected.');
        end
        
        % Turn off brushing after selection
        brush off;
    end
end
