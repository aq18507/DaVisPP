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