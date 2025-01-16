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
clear; close all; clc;
cd(fileparts(matlab.desktop.editor.getActiveFilename));
addpath("Scripts\");
addpath("Analysis\");
preamble;

%% PATH TO DATA DIRECTORY
% This defines the path to the data directly. Note that this can be an
% aboslute or relative path.data.
% file.path = "D:\Natural Feather - Experimental\DIC\Export\P05\P5_DS_L08_A0_2024-08-21\";
file.path = "D:\Natural Feather - Experimental\DIC\Export\P05\P5_US_L08_A0_2024-08-21_03\";

%% PATH TO ORIGINAL PROJECT
% This path only required if for instance when the manual data picking
% function is used
% Defualt = Commented out
file.project_path = "D:\Natural Feather - Experimental\DIC\Natural_Feather_240821\";
% file.project = "P5_DS_L08_A0_2024-08-21";
file.project = "P5_US_L08_A0_2024-08-21_03";
% file.subset = "Processing_subset=37_step=12_2024-08-21";

%% DATA PICK
% To select data points manually using the dataPick module then the
% configuration then this will need to be slected here.
% Note: For this to work, the calibration file is requred from the DIC
% analys. For that reason the path to the original project is required.
% Defualt = 0;
analysis.data_pick = 1;

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
analysis.type = 0;

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
analysis.range = 1;%[2:30];

%% MESH SIZE
% NOTE: This is not currently used
analysis.mesh_size = 100;

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
% %% DEFINE FUNCTIONS
% R = @(a) [cosd(a) -sind(a); sind(a) cosd(a)];

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
% Check whether the project path is defined if the manual data pick module
% is enabled
if analysis.data_pick == 1
    if ~isfield(file,"project_path") && ~isfield(file,"project")
        error("Using manual data pick requires the project path to be defined" + ...
            "in the variable file.project_path and file.project");
    end
end

%% ERASE UNUSED DATA
clear dat file_name error_num old;

%% LOAD MODULES
% Load raw data to the data struct
if analysis.data_reload == 1
    [data,file] = dataLoad(file);
end

% Point Track across all files
if analysis.pointTrack_reload
    [data] = pointTrack(file,data);
end

% Manual data pick
if analysis.data_pick == 1
    [calibration,file] = calibrationLoad(file);
end

% If selected print variables
if analysis.var_print == 1
    varPrint(file,analysis);
end


%% SPECIFIC ANALYSIS
% Preamble
close all;

% Process the loaded data and sort it based on the data.index_matrix
data = dataProcessor(file,analysis,data);

% Select points defining the Rachis or if the rachis_idx already exists
% then load this file instead
data.dataSelectOutput = 'rachis_idx';
settings.name = 'rachis';

name = sprintf("DaVisPP_%s.mat",settings.name);
path = sprintf("%s%s",file.path,name);

if exist(path,"file")
    dat = load(path);
    data.(data.dataSelectOutput) = dat.(data.dataSelectOutput);
    clear dat;
else
    file.camera = 1;
    data = dataSelect(data.rawData,calibration,file,data,settings);
end

%% OUTPUT

% Analysis which looks tracks the selected points of the rachis
% rachisAnalysis(data);
rachisAnalysisAnimation(data,file);


% %% DEV
% 
% r = data.rachis_idx;
% for i = 1%:2%file.num
%     t = 1:size(r,2);
%     xr = flip(data.processed.x(r,i)');
%     yr = flip(data.processed.y(r,i)');
%     zr = flip(data.processed.z(r,i)');
% 
%     [xr,idx] = sort(xr);
%     yr = yr(idx);
%     zr = zr(idx);
% 
%     % Create the 3D spline
%     pp = defineSpline3D(t, xr, yr, zr);
% 
% 
%     % Define the point on the spline where we want to create the surface
%     t_point = 5;  % For example, at t = 3
% 
%     % Call the function to create a perpendicular surface with a given radius
%     radius = 50;
%     num_points = 5;
%     [~,surface_points_s1,surface_points_s2] = perpendicularSurfaceToSpline(pp, t_point, radius, num_points);
% 
%     xx = surface_points_s1(2:end,1)';
%     yy = surface_points_s1(2:end,2)';
%     zz = surface_points_s1(2:end,3)';
% 
%     % Create a grid of points from the x and y data
%     density = 50;
%     [Y1, Z1] = meshgrid(linspace(min(yy), max(yy), density), linspace(min(zz), max(zz), density));
% 
%     % Interpolate Z values using griddata (non-collinear points)
%     X1 = griddata(yy, zz, xx, Y1, Z1, 'linear');
% 
%     % Plot the surface
%     surf(X1, Y1, Z1);
% 
%     xx = surface_points_s2(2:end,1)';
%     yy = surface_points_s2(2:end,2)';
%     zz = surface_points_s2(2:end,3)';
% 
%     % Create a grid of points from the x and y data
%     density = 50;
%     [Y2, Z2] = meshgrid(linspace(min(yy), max(yy), density), linspace(min(zz), max(zz), density));
% 
%     % Interpolate Z values using griddata (non-collinear points)
%     X2 = griddata(yy, zz, xx, Y2, Z2, 'linear');
% 
%     % Plot the surface
%     surf(X2, Y2, Z2);
% 
% 
%     % [X,Y,Z] = meshgrid(surface_points(2:end,1)',surface_points(2:end,2)',surface_points(2:end,3)')
%     % surf(X,Y,Z)
% 
%     % dat = table(xr',yr',zr','VariableNames', {'X', 'Y', 'Z'});
%     % 
%     % polynomialModel = fit([dat.X, dat.Y], dat.Z, 'poly23'); % poly23 is a 2nd-degree in X, 3rd-degree in Y
%     % 
%     % % View the coefficients of the polynomial
%     % disp(polynomialModel)
%     % 
%     % % Use the fitted model to predict values
%     % predictedZ = polynomialModel(xr, yr);
%     % 
%     % % Plot the original data and the fitted surface
%     % figure;
%     scatter3(xr, yr, zr, 'filled')  % Plot original data points
%     % hold on
%     % % % plot(polynomialModel)         % Plot the fitted surface
%     % xlabel('X')
%     % ylabel('Y')
%     % zlabel('Z')
%     % hold off
% 
% end
% axis equal;


















% % Extract data points from the data.processed and the data.rachis_idx
% % matrices
% r = data.rachis_idx;
% xr = data.processed.x(r,:);
% yr = data.processed.y(r,:);
% zr = data.processed.z(r,:);
% 
% scatter3(xr(:,1),yr(:,1),zr(:,1),'filled','o','g');
% hold on
% 
% xr = flip(data.processed.x(r,:)');
% yr = flip(data.processed.y(r,:)');
% zr = flip(data.processed.z(r,:)');
% 
% 
% % [xr,idx] = sort(xr);
% % yr = yr(idx);
% % zr = zr(idx);
% 
% % scatter3(xr, yr, zr,'r');
% plot3(xr, yr, zr,'Color','r');
% 
% r = data.rachis_idx;
% for i = 1%:file.num
%     xr = flip(data.processed.x(r,i)');
%     yr = flip(data.processed.y(r,i)');
%     zr = flip(data.processed.z(r,i)');
% 
%     [xr,idx] = sort(xr);
%     yr = yr(idx);
%     zr = zr(idx);
% 
%     dat = table(xr',yr',zr','VariableNames', {'X', 'Y', 'Z'});
% 
%     polynomialModel = fit([dat.X, dat.Y], dat.Z, 'poly23'); % poly23 is a 2nd-degree in X, 3rd-degree in Y
% 
%     % View the coefficients of the polynomial
%     disp(polynomialModel)
% 
%     % Use the fitted model to predict values
%     predictedZ = polynomialModel(xr, yr);
% 
%     % Plot the original data and the fitted surface
%     figure;
%     scatter3(xr, yr, zr, 'filled')  % Plot original data points
%     hold on
%     plot(polynomialModel)         % Plot the fitted surface
%     xlabel('X')
%     ylabel('Y')
%     zlabel('Z')
%     title('Fitted 3D Polynomial Surface')
%     hold off
% 
% end
% axis equal;





% %% MAIN SCRIPT
% 
% Z_displacement_max = nan(1,file.num);
% Y_displacement_max = nan(1,file.num);
% Eyy_S_max = nan(1,file.num);
% 
% zi = 1;
% for i = analysis.range
%     name = file.name(i);
%     fig.name = sprintf("%s_%s",file.name(i),analysis.var);
%     if zi == 1
%         analysis.variables = data.raw.(name).Properties.VariableNames;
%         fig.legend_variables.c = fig.legend_variables.raw(find((analysis.var == analysis.variables) == 1));
%         fig.legend_variables.x = fig.legend_variables.raw(1);
%         fig.legend_variables.y = fig.legend_variables.raw(2);
%         fig.legend_variables.z = fig.legend_variables.raw(3);
%     end
% 
%     %% Data Porcessing
% 
%     x = data.raw.(name).x_mm_;     y = data.raw.(name).y_mm_;     z = data.raw.(name).z_mm_;     c = data.raw.(name).(analysis.var);
% 
%     rawData.x = x;  rawData.y = y;  rawData.z = z;
% 
%     z_min_0 = min(z);     z = z - z_min_0;
%     x_min_0 = min(x);     x = x - x_min_0;
%     y_min_0 = min(y);     y = y - y_min_0;
% 
%     dx = data.raw.(name).X_displacement_mm_;
%     dy = data.raw.(name).Y_displacement_mm_;
%     dz = data.raw.(name).Z_displacement_mm_;
% 
%     if i > 1
%         x = x + dx;
%         y = y + dy;
%         z = z + dz;
%     end
% 
%     % x_min = min(x);    x_max = max(x);
%     % y_min = min(y);    y_max = max(y);
%     % 
%     % xlin = linspace(x_min,x_max,analysis.mesh_size);
%     % ylin = linspace(y_min,y_max,analysis.mesh_size);
%     % 
%     % [X,Y] = meshgrid(xlin,ylin);
%     % 
%     % fz = scatteredInterpolant(x,y,z);
%     % Z = fz(X,Y);
% 
%     %% PRINT SCATTER FIGURE
%     % Create Table contating the data for scatter figure
%     if analysis.type == 0
%     elseif analysis.type == 1
%         export_data = table(x,y,z,c);
% 
%         % Create Figure
%         F = figure(zi);
% 
%         setLaTeX(fig.font_size);
%         scatter3(export_data,"x","y","z","filled","ColorVariable","c")
%         % Colorbar
%         if ~isfield(fig,"color_scheme") 
%             fig.color_scheme = "parula";
%         end
%         fig.cmap = str2func(fig.color_scheme);
%         if isfield(fig,"color_steps")
%             colormap(F,fig.cmap(fig.color_steps));
%         else
%             colormap(F,fig.cmap());
%         end
%         if isfield(fig,"colorbar_range")
%             caxis(fig.colorbar_range)
%         end
%         fig.col = colorbar;
%         fig.col.Label.String = fig.legend_variables.c;
%         fig.col.Label.Interpreter = 'latex';
%         fig.col.TickLabelInterpreter = 'latex';
%         axis equal;
%         % Labels
%         xlabel(fig.legend_variables.x)
%         ylabel(fig.legend_variables.y)
%         zlabel(fig.legend_variables.z)
% 
%         view([180 0])
% 
%         % Print figure
%         if fig.save == 1
%             printFigure(F,fig.name)
%         end
%     elseif analysis.type == 10
%         % close all;
%         % file.camera = 1;
%         % data.dataSelectOutput = 'rachis_idx';
%         % 
%         % settings.name = 'rachis';
%         % 
%         % name = sprintf("DaVisPP_%s.mat",settings.name);
%         % path = sprintf("%s%s",file.path,name);
%         % 
%         % if exist(path,"file")
%         %     load(path);
%         % else
%         %     rachis_idx = dataSelect(rawData,calibration,file,data,settings);
%         % end
%         % % name = 'DaVisPP_Rachis';
%         % % rachis_idx = data.rachis;
%         % 
%         % rachis = data.index_matrix(rachis_idx,:);
%         % 
%         % for i = 1:size(rachis,2)
%         %     name = file.name(i);
%         %     x = data.raw.(name).x_mm_;     y = data.raw.(name).y_mm_;     z = data.raw.(name).z_mm_;     %c = data.raw.(name).(analysis.var);
%         % 
%         %     rawData.x = x;  rawData.y = y;  rawData.z = z;
%         % 
%         %     z_min_0 = min(z);     z = z - z_min_0;
%         %     x_min_0 = min(x);     x = x - x_min_0;
%         %     y_min_0 = min(y);     y = y - y_min_0;
%         % 
%         %     dx = data.raw.(name).X_displacement_mm_;
%         %     dy = data.raw.(name).Y_displacement_mm_;
%         %     dz = data.raw.(name).Z_displacement_mm_;
%         % 
%         %     if i > 1
%         %         x = x + dx;
%         %         y = y + dy;
%         %         z = z + dz;
%         %     end
%         %     r = rachis(:,i);
%         %     r(isnan(r)) = [];
%         %     xr = x(r,:);
%         %     yr = y(r,:);
%         %     zr = z(r,:);
%         % 
%         %     if i == 1
%         %         set(gca,'Color','none');
%         %         plot1 = scatter3(xr,yr,zr);
%         %         hold on;
%         %     else 
%         %         plot1.XData = xr;
%         %         plot1.YData = yr;
%         %         plot1.ZData = zr;
%         %         pause(0.2);
%         %     end
%         %     axis equal;
%         % end
%     elseif analysis.type == 2
%         %% PRINT 2D PLOT
% %         F = figure(zi);
%         hold on;
%         setLaTeX(fig.font_size);
%         scatter(x,y);
%         axis equal;
%         % Print figure
%         if fig.save == 1
%             printFigure(F,fig.name)
%         end
%     end
%     zi = zi + 1;
% end