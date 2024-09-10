function xxx = simple_gui_scatter_plot()
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

    % xxx = @finish_selection_callback

    % Create a button to finish selection
    uicontrol('Style', 'pushbutton', 'String', 'Finish Selection', ...
              'Position', [20 20 120 30], ...
              'Callback', xxx=@finish_selection_callback);

    % Create a button to close the GUI
    uicontrol('Style', 'pushbutton', 'String', 'Close', ...
              'Position', [150 20 100 30], ...
              'Callback', @(src, event) close(fig));

    % hold off;

    % Enable brushing
    brush on;  % Turn on the brush tool

    % Function to handle point selection
    function xxx = finish_selection_callback(~, ~)
        % Get the brush selection
        selectedPoints = get(hScatter, 'BrushData');
        xxx = selectedPoints;
        
        % Highlight selected points in green
        if any(selectedPoints)
            % Find the indices of selected points
            selectedIdx = find(selectedPoints);
            scatter(x(selectedIdx), y(selectedIdx), 80, 'g', 'filled');  % Highlight selected points
            disp('Selected points highlighted in green.');
        else
            disp('No points were selected.');
        end
        
        % Turn off brushing after selection
        brush off;
    end
end
