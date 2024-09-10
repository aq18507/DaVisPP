


function [selectedXData, selectedYData] = DataPickerExample
    close all;
    % create some test data and plot it
    x = -2*pi:0.1:2*pi;
    y = sin(x);
    hFig = figure;
    hPlot = plot(x,y);
    
    % create and enable the brush object
    hBrush = brush(hFig);
    hBrush.ActionPostCallback = @OnBrushActionPostCallback;
    hBrush.Enable = 'on';
    
    selectedXData = [];
    selectedYData = [];
    
    % select 4 sets of data points
    for x=1:4
        fprintf('select some points.\n');
        uiwait;
    end
    
    % turn off the brush
    hBrush.Enable = 'off';
    function OnBrushActionPostCallback(~, ~)
       
        xData = hPlot.XData;
        yData = hPlot.YData;
        brushedDataIndices = hPlot.BrushData;
        selectedXData = [selectedXData xData(logical(brushedDataIndices))];
        selectedYData = [selectedYData yData(logical(brushedDataIndices))];
        
        uiresume;
    end
end