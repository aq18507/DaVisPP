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
% This defines the path to the data directly. Noth that this can be an
% aboslute or relative path.
path = "D:\Rafa_tharan\AF_Sam_sml_trial\NF_P4_20mm\";

%% ANALYSIS TYPE
% 1 =   Scatter Plot: Tracking individual points which are directly pulled
%       from the .csv file.
analysis_type = 2;

%% VARIABLE
% This is the variable which is used to in the analysis. Note that this
% must match the output from the <var_print>. 
var = "Displacement_mm_";

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

%% SAVE FIGURE
% 1 =   Saves figure into the figure directory using the same name as the
%       original .csv file had.
% 0 =   Prevents figure from beingg saved. This might be usefull when
%       testing the function as saving the figure takes a significant
%       amount of time.
save_fig = 0;

%% PRINT ALL AVAILABLE VARIABLES
% 1 =   This prints all variables into the command line window. This is 
%       usefull when setting up an alaysis.
% 0 =   Prevent variables to be printed into the command window.
var_print = 0;

%% FONT SIZE
% This variable defines the font size of the figure. This is usefull wne
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
mesh_size = 100;

% Orientation
%~~~~~~~~~~~~~%
% Fig_view = ;

%% DEFINE FUNCTIONS
R = @(a) [cosd(a) -sind(a); sind(a) cosd(a)];

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
    end

    %% PRINT SURF FIGURE

    % Data cleanup
    zlin = nan([1 mesh_size]);


%     fznan = scatteredInterpolant(x,y,zlin);


%     [xi,yi,zii] = meshgrid(xlin,ylin,zlin);

    %         |
    %%%% KEEP V
%     scatter(x,y);
%     axis equal;
    dat = [x,y];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Define the coordinates and the corresponding data values
% Example coordinates (replace with your actual coordinate data)
xi = linspace(0, 10, size(dat, 2));
yi = linspace(0, 5, size(dat, 1));

% Create a meshgrid for the surface plot
[X, Y] = meshgrid(xi, yi);

% Create a figure
figure;

% Create a surface plot
surf(X, Y, dat);

% Customize the plot appearance
title('Surface Plot with Holes');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
colormap('jet'); % You can choose a different colormap if needed

% Add a color bar for reference
colorbar;

% Adjust the view angle if needed
view(3);

% Show the grid if necessary
grid on;

% Add other customizations as needed

% Save the figure if you want
% saveas(gcf, 'surface_plot_with_holes.png');

% Display the figure
disp('Surface plot created successfully.');


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



%     scatter(xi,yi,"red")

    % Figure
%     fig = figure(zi);
%     Z = griddata(x,y,z,X,Y,"cubic");
% %     Znan = griddata(x,y,zlin,X,Y,"cubic");
%     s = surf(X,Y,Z);
%     s.EdgeColor = 'none';

%     tri = delaunay(x,y);
%     trisurf(tri,x,y,z);
    
    axis equal


    %% OLD SHITE!!!!

    xi = X(1,mesh_size) - X(1,1);
    yi = Y(mesh_size,1) - Y(1,1);
    z1 = Z(1,mesh_size) - Z(1,1);
    z2 = Z(mesh_size,1) - Z(1,1);


%     a = -asind(z2/yi);
%     b = -asind(z1/xi);
%     % Rotate around x-axis
%     r1 = R(a)*[y';z'];
%     y = r1(1,:)';    z = r1(2,:)';
%     % Rotate around y-axis
%     r1 = R(b)*[x';z'];
%     x = r1(1,:)';    z = r1(2,:)';

    x_min = min(x);    x_max = max(x);
    y_min = min(y);    y_max = max(y);
    z_min = min(z);    z_max = max(z);

    xlin = linspace(x_min,x_max,mesh_size);
    ylin = linspace(y_min,y_max,mesh_size);

    [X,Y] = meshgrid(xlin,ylin);

    fz = scatteredInterpolant(x,y,z);
    Z = fz(X,Y);

    fc = scatteredInterpolant(x,y,c);
    C = fc(X,Y);

%     Z_displacement_max(i) = max(data.Z_displacement_mm_);
%     Y_displacement_max(i) = max(data.Y_displacement_mm_);
%     Eyy_S_max(i) = max(data.Eyy_S_);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%     if fig_print == 1
%         fig = figure;
%         setLaTeX(FontSize);
%         s = surf(X,Y,C);
%         c = jet(color_steps);
%         colormap(c);
% %         view(2);
% %         view(90,0);
% %         s = surf(X,Y,Z,C); %interpolated
%         if exist("colorbar_range","var")
%             caxis(colorbar_range)
%         end
%         s.EdgeColor = 'none';
%         axis tight; hold on
%         axis equal;
%         col = colorbar;
%         col.Label.String = '$\epsilon_{yy}$';
%         col.Label.Interpreter = 'latex';
%         col.TickLabelInterpreter = 'latex';
%         if save_fig == 1
%             printFigure(fig,name);
%         end
%     elseif fig_print == 2
%         fig = figure;
%         setLaTeX(FontSize);
%         s = surf(X,Y,C);
%         c = jet(color_steps);
%         c = c(2:13,:);
%         colormap(c);
%         view(90,0);
% %         s = surf(X,Y,Z,C); %interpolated
%         if exist("colorbar_range","var")
%             caxis(colorbar_range)
%         end
%         s.EdgeColor = 'none';
%         axis tight; hold on
%         daspect([1 max(Y,[],"all")/(y_max) 1])
%         zlim([0 6.5])
%         col = colorbar;
%         col.Label.String = '$dz$ [mm]';
%         col.Label.Interpreter = 'latex';
%         col.TickLabelInterpreter = 'latex';
%         zlabel("$dz$ [mm]")
%         ylabel("Stretch Ratio $\lambda$")
%         ylim([0 1.4])
%         if save_fig == 1
%             printFigure(fig,name);
%         end
%     elseif fig_print == 3
%         fig = figure;
%         setLaTeX(FontSize);
%         s = surf(X,Y,C);
%         c = jet(color_steps);
%         c = c(2:13,:);
%         colormap(c);
%         view(90,0);
% %         s = surf(X,Y,Z,C); %interpolated
%         if exist("colorbar_range","var")
%             caxis(colorbar_range)
%         end
%         s.EdgeColor = 'none';
%         axis tight; hold on
%         daspect([1 max(Y,[],"all")/(y_max) 1])
%         zlim([0 6.5])
%         col = colorbar;
%         col.Label.String = '$dz$ [mm]';
%         col.Label.Interpreter = 'latex';
%         col.TickLabelInterpreter = 'latex';
%         zlabel("$dz$ [mm]")
%         ylabel("Stretch Ratio $\lambda$")
%         if save_fig == 1
%             printFigure(fig,name);
%         end
%     elseif fig_print == 4
%         name = sprintf("%s_%s_contour",erase(file_name,".csv"),var);
%         fig = figure;
%         setLaTeX(FontSize);
%         s = surf(X,Y,C);
%         c = jet(color_steps);
%         c = c(2:13,:);
% 
%         % Create x and y over the slicing plane
%         slice_y = [17.56 21.94 24.73 29.07];
%         slice_y = slice_y(zi);
%         xq=linspace(0,90,100);
%         yq=linspace(slice_y,slice_y,100);
%         
%         % Interpolate over the surface
%         zq=interp2(X,Y,C,xq,yq); 
%         
%         dq=sqrt((xq-0).^2 + (yq-0).^2);
%         plot(xq,zq)
%         axis equal
%         box off;
%         grid on;
%         ylim([0 6])
%         xlim([0 50])
%         ylabel("$dz$ [mm]");
%         xlabel("Slice through $y$ axis [mm]")
%         if save_fig == 1
%             printFigure(fig,name);
%         end
%     elseif fig_print == 5
%         name = sprintf("%s_%s_OrientationFigure",erase(file_name,".csv"),var);
%         fig = figure;
%         setLaTeX(FontSize);
%         s = surf(X,Y,C);
%         c = jet(color_steps);
%         colormap(c);
% %         view(2);
% %         view(90,0);
% %         s = surf(X,Y,Z,C); %interpolated
%         if exist("colorbar_range","var")
%             caxis(colorbar_range)
%         end
%         s.EdgeColor = 'none';
%         axis tight; hold on
%         axis equal;
%         col = colorbar;
%         col.Label.String = '$dz$';
%         col.Label.Interpreter = 'latex';
%         col.TickLabelInterpreter = 'latex';
%         if save_fig == 1
%             printFigure(fig,name);
%         end
%     end
% 
    zi = zi + 1;
end

% setLaTeX(10);
% 
% fig = figure;
% fig.Position = [100 100 600 300];
% 
% hold on
% range_0 = 16;
% range_1 = 116;
% 
% lambda = (L_0 + Y_displacement_max(range_0:range_1))/L_0;
% plot(lambda,Z_displacement_max(range_0:range_1))
% % plot(range_0:range_1,Z_displacement_max(11:end))
% ylabel("Out-of-Plain deflection [mm]")
% xlabel("$\lambda$")
% box on;
% printFigure(fig,"dz_dp_lambda");

% FEA = readtable("FEA_RAW_DATA.xlsx");
% idx = find(FEA.Time == 1, 1, 'last' );
% FEA_dz = FEA.dz(idx:end,:)*-1;
% FEA_lambda = 1 + ((FEA.Time(idx:end,:) - 1)*25.2)./42;

% setLaTeX(10);
% 
% fig = figure;
% fig.Position = [100 100 600 250];
% 
% hold on
% range_0 = 16;
% range_1 = 116;

% lambda = (L_0 + Y_displacement_max(range_0:range_1))/L_0;
% plot(lambda,Z_displacement_max(range_0:range_1))
% plot(FEA_lambda,FEA_dz);
% % plot(range_0:range_1,Z_displacement_max(11:end))
% ylabel("Out-of-Plain deflection [mm]")
% xlabel("$\lambda$")
% xlim([1 1.6]);
% legend("Experimental","FEA",Location="northeast");
% legend boxoff
% box on;
% printFigure(fig,"dz_lambda_FEA_EXP");