# DaVisPP

DaVisPP is a lightweight Matlab post-processer for laVision DaVis created .csv files.

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

``1`` = Saves figure into the figure directory using the same name as the original .csv file had.

``0`` = Prevents figure from being saved. This might be useful when testing the function as saving the figure takes a significant amount of time.

*Example*
```matlab
save_fig = 0;
```