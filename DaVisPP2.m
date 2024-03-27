%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.240306                                                    %
% (c)2024 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.210709: - Initial version
% v1.240306: - Complete revision for general use
% v2.240318: - substantial rewrite so that the data loaded is retained but
%              that the script can also track data points between files.
%              Note that this is no longer compatible with the previous
%              version.
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
% aboslute or relative path.data.
file.path = "D:\Rafa_tharan\AF_Sam_sml_trial\NF_P4_20mm_1st\";

%% DATA RELOAD
% This forces the script to reload the data into the data variable. If the
% raw data set has not changed this should be set to "0" as the script will
% automatically detect whether a data is already loaded and if necessary
% load.
% Default = 0
analysis.data_reload = 0;

%% DATA PPOINT TRACK
% This can be used to force the pointTrack function to be run. In general
% this is not needed as the script checks whether data is present. That
% said, it might be necessary to reload the data in some instances. Set to
% 1 if this is the case.
% Default = 0
analysis.pointTrack_reload = 0;

%% ANALYSIS TYPE
% 0 =   No analysis
% 1 =   Scatter Plot: Tracking individual points which are directly pulled
%       from the .csv file.
analysis.type = 2;

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
analysis.range = [2:30];

%% VARIABLE
% This is the variable which is used to in the analysis. Note that this
% must match the output from the <analysis.var_print>. 
analysis.var = "Displacement_mm_";

%% PRINT ALL AVAILABLE VARIABLES
% 1 =   This prints all variables into the command line window. This is 
%       usefull when setting up an alaysis.
% 0 =   Prevent variables to be printed into the command window.
analysis.var_print = 0;

%% SAVE FIGURE
% 1 =   Saves figure into the figure directory using the same name as the
%       original .csv file had.
% 0 =   Prevents figure from being saved. This color_stepsmight be useful when
%       testing the function as saving the figure takes a significant
%       amount of time.
fig.save = 0;

%% FONT SIZE
% This variable defines the font size of the figure. This is useful when
% exporting the figure for a report.
fig.font_size = 12;

%% COLORBAR RANGE (OPTIONAL)
% This value defines the colorbar range which is useful when comparing
% different figures with each other. This can be turned on by uncommenting
fig.colorbar_range = [0 30];

%% COLOR STEPS (OPTIONAL)
% If this value is uncommented it will define the number of color steps.
fig.color_steps = 24;

%% COLOR SCHEME (OPTIONAL)
% Check https://uk.mathworks.com/help/matlab/ref/colormap.html for more
% detail to add different color schemes. All color schemes listed in the
% link above can be used. The parula is the default scheme. Note that the
% option must exactly match the colormap syntax. If this is commented out,
% the default is autmatically chosen.
% - parula (default)
% - jet
% - ...
fig.color_scheme = "jet";

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%% INDEX DATA DIRECTORY
file.meta = dir(sprintf("%s*.csv",file.path));
file.num = size(file.meta,1);

%% PREPARE DATA
% Load all files
if strcmp(analysis.range,"all")
    analysis.range = 1:file.num;
end
% Load the legend variables
file_name = file.meta(1).name;
dat = readtable(sprintf("%s%s",file.path,file_name),VariableNamingRule="preserve");
fig.legend_variables.raw = dat.Properties.VariableNames;

%% CHECK INPUTS
% Check file range. The maximum value cannot be larger than the number of
% .csv file present it the data directly.
error_num = 0;
if any(analysis.range > file.num)
    warning("The maximum value in <file_range> cannot be higher than the " + ...
        "number of files (%0.f) defined in <file_range> in the data " + ...
        "directory.",file.num);
    error_num = error_num + 1;
end
% Check whether the variable defined in contained in the list of variables
% within the data set.
dat = readtable(sprintf("%s%s",file.path,file_name),VariableNamingRule="modify");
analysis.variables = dat.Properties.VariableNames;
if ~any(analysis.var == analysis.variables)
    warning("The Variable <%s> defined in <var> is not contained in the raw data", ...
        analysis.var);
    error_num = error_num + 1;
end
% Run error command
if error_num == 1
    error("There is an input error. Look at the warnings before continuing!");
elseif error_num > 1
    error("There are %0.f input errors. Look at the warnings before continuing!", ...
        error_num);
end
% Check whether DaVisPP_data.mat is present. If it is then load the data
% .mat file and check whether the file range matches. If it does not or if
% the DaVisPP_data.mat file is not present reload all the data.
if ~isfile(sprintf("%s%s",file.path,"DaVisPP_data.mat"))
    analysis.data_reload = 1;
    analysis.pointTrack_reload = 1;
    file = nameLoad(file);
else
    old = load(sprintf("%s%s",file.path,"DaVisPP_data.mat"),"file");
    file = nameLoad(file);
    if ~isequal(old.file.meta,file.meta)
        analysis.data_reload = 1;
    else
        load(sprintf("%s%s",file.path,"DaVisPP_data.mat"),"data");
    end
    if ~isfield(data,"index_matrix")
        analysis.pointTrack_reload = 1;
    end
end

%% ERASE UNUSED DATA
clear dat file_name error_num old;

%% MODULES
% Load raw data to the data struct
if analysis.data_reload == 1
    [data,file] = dataLoad(file);
end

% Point Track across all files
if analysis.pointTrack_reload
    [data] = pointTrack(file,data);
end

% If selected print variables
if analysis.var_print == 1
    varPrint(file,analysis);
end

%% MAIN SCRIPT
zi = 1;
for i = analysis.range
    name = file.name(i);
    fig.name = sprintf("%s_%s",file.name(i),analysis.var);
    if zi == 1
        analysis.variables = data.raw.(name).Properties.VariableNames;
        fig.legend_variables.c = fig.legend_variables.raw( ...
            find((analysis.var == analysis.variables) == 1));
        fig.legend_variables.x = fig.legend_variables.raw(1);
        fig.legend_variables.y = fig.legend_variables.raw(2);
        fig.legend_variables.z = fig.legend_variables.raw(3);
    end

    %% Data Porcessing
    x = data.raw.(name).x_mm_;     y = data.raw.(name).y_mm_;     
    z = data.raw.(name).z_mm_;     c = data.raw.(name).(analysis.var);

    z_min_0 = min(z);     z = z - z_min_0;
    x_min_0 = min(x);     x = x - x_min_0;
    y_min_0 = min(y);     y = y - y_min_0;

    dx = data.raw.(name).X_displacement_mm_;
    dy = data.raw.(name).Y_displacement_mm_;
    dz = data.raw.(name).Z_displacement_mm_;
    
    if i > 1
        x = x + dx;
        y = y + dy;
        z = z + dz;
    end

    %% PRINT SCATTER FIGURE
    % Create Table contating the data for scatter figure
    if analysis.type == 0
    elseif analysis.type == 1
        export_data = table(x,y,z,c);
        
        % Create Figure
        F = figure(zi);
        setLaTeX(fig.font_size);
        scatter3(export_data,"x","y","z","filled","ColorVariable","c")
        % Colorbar
        if ~isfield(fig,"color_scheme") 
            fig.color_scheme = "parula";
        end
        fig.cmap = str2func(fig.color_scheme);
        if isfield(fig,"color_steps")
            colormap(F,fig.cmap(fig.color_steps));
        else
            colormap(F,fig.cmap());
        end
        if isfield(fig,"colorbar_range")
            caxis(fig.colorbar_range)
        end
        fig.col = colorbar;
        fig.col.Label.String = fig.legend_variables.c;
        fig.col.Label.Interpreter = 'latex';
        fig.col.TickLabelInterpreter = 'latex';
        axis equal;
        % Labels
        xlabel(fig.legend_variables.x)
        ylabel(fig.legend_variables.y)
        zlabel(fig.legend_variables.z)
        % Print figure
        if fig.save == 1
            printFigure(F,fig.name)
        end
    elseif analysis.type == 2
        %% PRINT 2D PLOT
%         F = figure(zi);
        hold on;
        setLaTeX(fig.font_size);
        scatter(x,y);
        axis equal;
        % Print figure
        if fig.save == 1
            printFigure(F,fig.name)
        end
    end
    zi = zi + 1;
end