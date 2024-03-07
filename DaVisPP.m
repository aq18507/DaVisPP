%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240306                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.210709: - Initial version
% v1.240306: - Complete revision for general use
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%% PREAMBLE
% WARNING: Do not change unless absolutely necessary!
% ‾‾‾‾‾‾‾‾
warning('off','MATLAB:table:ModifiedAndSavedVarnames');
clear all; close all; clc; %#ok<CLALL>
cd(fileparts(matlab.desktop.editor.getActiveFilename));
addpath("Scripts\");

%% PATH TO DATA DIRECTORY
% This defines the path to the data directly. Note that this can be an
% aboslute or relative path.
path = "D:\Rafa_tharan\AF_Sam_sml_trial\NF_P4_20mm\";

%% ANALYSIS TYPE
% 1 =   Scatter Plot: Tracking individual points which are directly pulled
%       from the .csv file.
analysis_type = 1;

%% FILE RANGE
% This array defines which files are evaluated and loaded. It can be all of
% them or only a selected few. Note that it will always load the first file
% as this is the one all subsequent data relies on. For that reason the
% first image is does not tecessary need to be specified here. Here are
% three options how this can be used
% #1 -> "all"   : By using the string "all" the script will automatically
%                 load all data
% #2 -> 1:n     : This method loads a range of data. For instance 2:15 or
%                 1:30 as long as the maximum value exists.
% #3 -> [2 3 7] : Loads a defined number of files.                                  
file_range = [2:10];

%% VARIABLE
% This is the variable which is used to in the analysis. Note that this
% must match the output from the <var_print>. 
var = "Displacement_mm_";

%% PRINT ALL AVAILABLE VARIABLES
% 1 =   This prints all variables into the command line window. This is 
%       usefull when setting up an alaysis.
% 0 =   Prevent variables to be printed into the command window.
var_print = 0;

%% SAVE FIGURE
% 1 =   Saves figure into the figure directory using the same name as the
%       original .csv file had.
% 0 =   Prevents figure from being saved. This might be useful when
%       testing the function as saving the figure takes a significant
%       amount of time.
save_fig = 0;

%% FONT SIZE
% This variable defines the font size of the figure. This is useful when
% exporting the figure for a report.
FontSize = 12;

%% COLORBAR RANGE (OPTIONAL)
% This value defines the colorbar range which is useful when comparing
% different figures with each other. This can be turned on by uncommenting
colorbar_range = [0 30];

%% COLOR STEPS (OPTIONAL)
% If this value is uncommented it will define the number of color steps.
color_steps = 24;

%% COLOR SCHEME (OPTIONAL)
% Check https://uk.mathworks.com/help/matlab/ref/colormap.html for more
% detail to add different color schemes. All color schemes listed in the
% link above can be used. The parula is the default scheme. Note that the
% option must exactly match the colormap syntax. If this is commented out,
% the default is autmatically chosen.
% - parula (default)
% - jet
% - ...
color_scheme = "jet";

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%% DEFINE FUNCTIONS
R = @(a) [cosd(a) -sind(a); sind(a) cosd(a)];
mesh_size = 100;

%% INDEX DATA DIRECTORY
files = dir(sprintf("%s*.csv",path));
files_num = size(files,1);

%% PREPARE DATA
% Load all files
if strcmp(file_range,"all")
    file_range = 1:files_num;
end
% Load the legend variables
file_name = files(1).name;
data = readtable(sprintf("%s%s",path,file_name),VariableNamingRule="preserve");
legend_variables.raw = data.Properties.VariableNames;

%% CHECK INPUTS
% Check file range. The maximum value cannot be larger than the number of
% .csv file present it the data directly.
error_num = 0;
if any(file_range > files_num)
    warning("The maximum value in <file_range> cannot be higher than the " + ...
        "number of files (%0.f) defined in <file_range> in the data " + ...
        "directory.",files_num);
    error_num = error_num + 1;
end
% Check whether the variable defined in contained in the list of variables
% within the data set.
data = readtable(sprintf("%s%s",path,file_name),VariableNamingRule="modify");
variables = data.Properties.VariableNames;
if ~any(var == variables)
    warning("The Variable <%s> defined in <var> is not contained in the raw data", ...
        var);
    error_num = error_num + 1;
end
% Run error command
if error_num == 1
    error("There is an input error. Look at the warnings before continuing!");
elseif error_num > 1
    error("There are %0.f input errors. Look at the warnings before continuing!", ...
        error_num);
end
%% MAIN SCRIPT

Z_displacement_max = nan(1,files_num);
Y_displacement_max = nan(1,files_num);
Eyy_S_max = nan(1,files_num);

zi = 1;
for i = file_range

    file_name = files(i).name;
    data = readtable(sprintf("%s%s",path,file_name),VariableNamingRule="modify");
    name = sprintf("%s_%s",erase(file_name,".csv"),var);
    if zi == 1
        variables = data.Properties.VariableNames;
        legend_variables.c = legend_variables.raw(find((var == variables) == 1));
        legend_variables.x = legend_variables.raw(1);
        legend_variables.y = legend_variables.raw(2);
        legend_variables.z = legend_variables.raw(3);
    end
    if var_print == 1
        if zi == 1
            fprintf("* * * * * * * * * * * * *\n" + ...
                    "*  Variables  Availabe  *\n" + ...
                    "* * * * * * * * * * * * *\n\n");
            for j = 1:size(variables,2)
                fprintf('%s\n',cell2mat(variables(j)));
            end
            fprintf("\n" + ...
                    "* * * * * * * * * * *\n" + ...
                    "*  Directory Stats  *\n" + ...
                    "* * * * * * * * * * *\n\n");
            fprintf("There are a total of %0.f .csv files in the <%s> directory\n", ...
                size(files,1),path);
        end
    end

    %% Data Porcessing

    x = data.x_mm_;     y = data.y_mm_;     z = data.z_mm_;     c = data.(var);

    z_min_0 = min(z);     z = z - z_min_0;
    x_min_0 = min(x);     x = x - x_min_0;
    y_min_0 = min(y);     y = y - y_min_0;

    dx = data.X_displacement_mm_;
    dy = data.Y_displacement_mm_;
    dz = data.Z_displacement_mm_;
    
    if i > 1
        x = x + dx;
        y = y + dy;
        z = z + dz;
    end

    x_min = min(x);    x_max = max(x);
    y_min = min(y);    y_max = max(y);

    xlin = linspace(x_min,x_max,mesh_size);
    ylin = linspace(y_min,y_max,mesh_size);

    [X,Y] = meshgrid(xlin,ylin);

    fz = scatteredInterpolant(x,y,z);
    Z = fz(X,Y);


    %% PRINT SCATTER FIGURE
    % Create Table contating the data for scatter figure
    if analysis_type == 1
        export_data = table(x,y,z,c);
        
        % Create Figure
        fig = figure(zi);
        setLaTeX(FontSize);
        scatter3(export_data,"x","y","z","filled","ColorVariable","c")
        % Colorbar
        if ~exist("color_scheme","var")
            color_scheme = "parula";
        end
        cmap = str2func(color_scheme);
        if exist("color_steps","var")
            colormap(fig,cmap(color_steps));
        else
            colormap(fig,cmap());
        end
        if exist("colorbar_range","var")
            caxis(colorbar_range)
        end
        col = colorbar;
        col.Label.String = legend_variables.c;
        col.Label.Interpreter = 'latex';
        col.TickLabelInterpreter = 'latex';
        axis equal;
        % Labels
        xlabel(legend_variables.x)
        ylabel(legend_variables.y)
        zlabel(legend_variables.z)
        % Print figure
        if save_fig == 1
            printFigure(fig,name)
        end
    elseif analysis_type == 2
        %% PRINT 2D PLOT
        fig = figure(zi);
        setLaTeX(FontSize);
        scatter(x,y);
        axis equal;
        % Print figure
        if save_fig == 1
            printFigure(fig,name)
        end
    end
    zi = zi + 1;
end