# DaVisPP

DaVisPP is a lightweight Matlab post-processer for laVision DaVis created .csv files. The main script is called ``DaVisPP2.m``, any helper scripts are stored in the directory ``./Scripts`` and do not need to be changed by the user. These scripts are required for the main script to run properly.

The script loads all the data from a data directory into the ``data.raw`` structured array which will contain all raw data. Once loaded it will then track all points across all files since the different ``.csv`` files might not necessarily contain all the same points. For that reason, the ``data.index_matrix`` is created where each column represents a file (*i.e.* ``1`` = ``B0001.csv``, ``2`` = ``B0002.csv``, ``3`` = ``B0003.csv``, ``n`` = ``B000n.csv``). Therefore, column $1$ refers to the first file *e.g.* ``B0001.csv`` which is the reference file where every other file is referenced to. 

![Alt text](https://github.com/aq18507/DaVisPP/blob/main/docs/reference.JPG?raw=true "Title")

Consider the figure above which shows a reference matrix, looking at row 5 column 1 and 2 for instance. This means that point ``5`` in the ``B0001.csv`` can be found row ``3`` in the files ``B0002.csv`` to ``B0007.csv``. Point the point in row 1 column 1 is no longer visible in the files ``B0002.csv`` to ``B0007.csv`` hence the ``NaN`` value. This matrix makes it relatively easy to track the points across all files as the data can be easily accessed using structure arrays. Please refer to the Matlab documentation for structure arrays which can be found here [``struct``](https://uk.mathworks.com/help/matlab/ref/struct.html).

## Getting Started

- **Option 1:** Used the download button in GitHub to get this repository.
- **Option 2:** Use the Git on to fetch this repository. Note that there is a difference in how this works between Windows and MacOS.

### Windows

> [!WARNING]
> Git is not installed by default on Windows. To check run ``git -v`` in command prompt. If it returns a version then it installed. If not, install GitHub [Git Download and install guide](https://github.com/git-guides/install-git).

- Go to the directory in which the config files should reside.
- Clone this git repository into an easily accessible location (ideally somewhere on the ``C`` drive on Windows).
- Right-click and select ``Open Git Bash here``.
- Use the ``git clone https://github.com/aq18507/DaVisPP.git`` command and hit enter. Now the directory is cloned.

### Mac

> [!NOTE]
> Git is installed by default on MacOS. To check the version run ``git -v`` in the terminal.

- Open the terminal program.
- Use the change directory ``cd /[your directory]/`` command to move to the directory of your choice.
- Use the ``git clone https://github.com/aq18507/DaVisPP.git`` command and hit enter. Now the directory is cloned.

## Working Principle

The program reads all specified ``.csv`` files into the program and generates for each file a scatter plot using the Matlab ``scatter3`` function to illustrate the physical displacement. The points in the scatter plot can be coloured using any of the exported variables.

### Input Data Format

The data format must be ``.csv`` for the script to read and ideally, the data is numbered sequentially to avoid having to sort the data within the Matlab script. DaVis does this as standard *i.e.* $B0001, B0002, B0003, B000n, ...$ which automatically loads the files in the correct order.

### Settings within the Script

The following explains the individual settings variables in the script. Note that the ones with an Asterix (``*``) are necessary, and the ones marked optional can be commented out.

#### ``path``*

This defines the path to the data directly. Note that this can be an absolute or relative path.

*Examples*

Absolute path
```matlab
path = "D:\[Path]\[To]\[Directory]\";
```
or relative path
```matlab
path = ".\Data\";
```

Note that MacOS requires ``/`` separators whereas Windows works with ``/``.

#### ``analysis_type``*

This is the type of analysis chosen. At the moment there is only one per-programmed type. For this reason this needs to be set to ``1`` but the user can program further types which can the be chosen here to save computational resources. 

*Example*

```matlab
analysis_type = 1;
```

#### ``file_range``*

This array defines which files are evaluated and loaded. It can be all of them or only a selected few. Note that it will always load the first file as this is the one all subsequent data relies on. For that reason, the first file does not necessarily need to be specified here.

*Examples*

Loading all files. By using the string ``"all"`` the script will automatically load all data
```matlab
file_range = "all";
```
Loading a range of files from file $2$ to $16$
```matlab
file_range = 2:16;
```
Load specific files
```matlab
file_range = [2 4 7 30];
```

#### ``var``*

This is the variable that is used in the analysis defined in colour in the scatter plot. Note that this must match one of the following variables:

```
x_mm_
y_mm_
z_mm_
X_displacement_mm_
Y_displacement_mm_
Z_displacement_mm_
Displacement_mm_
Exx_S_
Eyy_S_
Exy_S_
Poisson_sRatio_strainMin_max
Poisson_sRatio_Exx_Eyy
Poisson_sRatio_Eyy_Exx
Poisson_sRatio_strainMax_min
MaximumPrincipalStrain_S_
MinimumPrincipalStrain_S_
MaximumShearStrain_S_
MaximumShearAngle___
MaximumStrainAngle___
TrescaStrain_S_
VonMisesStrain_S_
du_dx_S_
du_dy_S_
dv_dx_S_
dv_dy_S_
Vorticity_z_S_
Height_mm_
du_dx_dv_dy_S_
Div_xy_S_
StereoReconstructionError_pixel_
```

*Example*
```matlab
var = "Displacement_mm_";
```

#### ``var_print``*

Prints all available variables as well as some debug information.

``1`` = This prints all variables into the command line window. This is useful when setting up an analysis.

``0`` = Prevent variables to be printed into the command window.

*Example*
```matlab
var_print = 1;
```

#### ``save_fig``*

This variable determines whether the figures should be saved in the ``Figure`` directory. Note that this automatically makes a directory if it does not already exist. This relies on the [``printFigure.m``](https://gatorcell.rmhaerospace.com/Scripts.html#printfigure) and [``setLaTeX.m``](https://gatorcell.rmhaerospace.com/Scripts.html#setlatex) functions which are documented in more detail on the *GATORcell* website. Click on the function for the documentation.

``1`` = Saves figure into the figure directory using the same name as the original ``.csv`` file had, (*i.e.* if the ``.csv`` file was **B0003.csv** then the figure will be called **B0003.svg**).

``0`` = Prevents figure from being saved. This might be useful when testing the function as saving the figure takes a significant amount of time.

*Example*
```matlab
save_fig = 0;
```

#### ``FontSize``*

This variable defines the font size of the figure in *pt*. This is useful when exporting the figure for a report.

*Example*
```matlab
FontSize = 12;
```

#### ``colorbar_range``(Optional)

This value defines the colour bar range which is useful when comparing different figures with each other. This can be turned on by uncommenting. In other words, it keeps the colour bar constant across all plots. If this is commented out it will auto-adjust the colour bar for each plot. The first value represents the lowest and the second the maximum value respectively.

*Example*
```matlab
colorbar_range = [0 30];
```

#### ``color_steps``(Optional)

If this value is uncommented it will define the number of color steps.

*Example*
```matlab
color_steps = 24;
```

#### ``color_scheme``(Optional)

Check [Matlab Colormap](https://uk.mathworks.com/help/matlab/ref/colormap.html) for more details to add different colour schemes. All colour schemes listed in the link can be used. The ``parula`` is the default scheme. Note that the option must exactly match the colormap syntax. If this is commented out, the default is automatically chosen. If this is commented out, ``parula`` will be automatically selected.

*Example*
```matlab
color_scheme = "jet";
```











## Old depreciated versions

This section describes old versions of the ``DaVisPP`` scripts. Note that they are no longer maintained. 

## DaVisPP

### Settings within the Script

The following explains the individual settings variables in the script. Note that the ones with an Asterix (``*``) are necessary, and the ones marked optional can be commented out.

#### ``path``*

This defines the path to the data directly. Note that this can be an absolute or relative path.

*Examples*

Absolute path
```matlab
path = "D:\[Path]\[To]\[Directory]\";
```
or relative path
```matlab
path = ".\Data\";
```

Note that MacOS requires ``/`` separators whereas Windows works with ``/``.

#### ``analysis_type``*

This is the type of analysis chosen. At the moment there is only one per-programmed type. For this reason this needs to be set to ``1`` but the user can program further types which can the be chosen here to save computational resources. 

*Example*

```matlab
analysis_type = 1;
```

#### ``file_range``*

This array defines which files are evaluated and loaded. It can be all of them or only a selected few. Note that it will always load the first file as this is the one all subsequent data relies on. For that reason, the first file does not necessarily need to be specified here.

*Examples*

Loading all files. By using the string ``"all"`` the script will automatically load all data
```matlab
file_range = "all";
```
Loading a range of files from file $2$ to $16$
```matlab
file_range = 2:16;
```
Load specific files
```matlab
file_range = [2 4 7 30];
```

#### ``var``*

This is the variable that is used in the analysis defined in colour in the scatter plot. Note that this must match one of the following variables:

```
x_mm_
y_mm_
z_mm_
X_displacement_mm_
Y_displacement_mm_
Z_displacement_mm_
Displacement_mm_
Exx_S_
Eyy_S_
Exy_S_
Poisson_sRatio_strainMin_max
Poisson_sRatio_Exx_Eyy
Poisson_sRatio_Eyy_Exx
Poisson_sRatio_strainMax_min
MaximumPrincipalStrain_S_
MinimumPrincipalStrain_S_
MaximumShearStrain_S_
MaximumShearAngle___
MaximumStrainAngle___
TrescaStrain_S_
VonMisesStrain_S_
du_dx_S_
du_dy_S_
dv_dx_S_
dv_dy_S_
Vorticity_z_S_
Height_mm_
du_dx_dv_dy_S_
Div_xy_S_
StereoReconstructionError_pixel_
```

*Example*
```matlab
var = "Displacement_mm_";
```

#### ``var_print``*

Prints all available variables as well as some debug information.

``1`` = This prints all variables into the command line window. This is useful when setting up an analysis.

``0`` = Prevent variables to be printed into the command window.

*Example*
```matlab
var_print = 1;
```

#### ``save_fig``*

This variable determines whether the figures should be saved in the ``Figure`` directory. Note that this automatically makes a directory if it does not already exist. This relies on the [``printFigure.m``](https://gatorcell.rmhaerospace.com/Scripts.html#printfigure) and [``setLaTeX.m``](https://gatorcell.rmhaerospace.com/Scripts.html#setlatex) functions which are documented in more detail on the *GATORcell* website. Click on the function for the documentation.

``1`` = Saves figure into the figure directory using the same name as the original ``.csv`` file had, (*i.e.* if the ``.csv`` file was **B0003.csv** then the figure will be called **B0003.svg**).

``0`` = Prevents figure from being saved. This might be useful when testing the function as saving the figure takes a significant amount of time.

*Example*
```matlab
save_fig = 0;
```

#### ``FontSize``*

This variable defines the font size of the figure in *pt*. This is useful when exporting the figure for a report.

*Example*
```matlab
FontSize = 12;
```

#### ``colorbar_range``(Optional)

This value defines the colour bar range which is useful when comparing different figures with each other. This can be turned on by uncommenting. In other words, it keeps the colour bar constant across all plots. If this is commented out it will auto-adjust the colour bar for each plot. The first value represents the lowest and the second the maximum value respectively.

*Example*
```matlab
colorbar_range = [0 30];
```

#### ``color_steps``(Optional)

If this value is uncommented it will define the number of color steps.

*Example*
```matlab
color_steps = 24;
```

#### ``color_scheme``(Optional)

Check [Matlab Colormap](https://uk.mathworks.com/help/matlab/ref/colormap.html) for more details to add different colour schemes. All colour schemes listed in the link can be used. The ``parula`` is the default scheme. Note that the option must exactly match the colormap syntax. If this is commented out, the default is automatically chosen. If this is commented out, ``parula`` will be automatically selected.

*Example*
```matlab
color_scheme = "jet";
```