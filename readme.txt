dataINT - Toolbox for INTERACTIVE reading and writing of csv- and xls-datafiles
==============================================================================

dataINT offers functions for convienient interactice im-/export of data files, 
as comma-separated-value- (*.csv, *.dat, *.txt) and binary Excel files (*.xls)
to or from a Scilab matrix. 

Parameters, to specify the im-/export, can convieniently entered in a dialog  
box and the file selection is done by the platform-specific 
file selection dialog.

You can specify the following im-/export parameters:
- Field separator (comma, semicolon, tab, space)
- Decimal separator (comma, point)
- Rows and Colums you want to import (DI_readcsv, DI_readxls only)
- Sheet you want to import (DI_readxls only)
- Number of lines to skip, e.g. header line(s) (DI_readcsv, DI_readxls only)
- Comment header line to describe your data (DI_writecsv only)

IMPORTANT: dataINT does not handle data from XML-based Excel files (.xlsx)!
NOTE: dataINT handles doubles only.

The functions can easily integrated in your own scripts to make use of 
dataINT's interactive functionality or to simplify your data import in 
Scilab's console.

FUNCTIONS:

* DI_readcsv
  Read comma-separated value files (*.csv, *.dat, *.txt) interactively.
* DI_readxls
  Read  binary Excel files (*.xls) interactively.
* DI_writecsv
  Write comma-separated value files (*.csv, *.dat, *.txt) interactively.

dataINT is available for Scilab 5.5.x and Scilab 6.0.x and cross-platform.

-------------------------------------------------------------------------------

CHANGELOG:

1.0.1 Bug fixes: 
- "test" print in DI_readcsv())
- Syntax/Calling Sequence missing bug in help-files
- some minor improvements
   
-------------------------------------------------------------------------------

COMPATIBILITY
Can be build, installed and run with Scilab 5.5.x and 6.0.x, cross-platform.

BUILD:
  * Decompress the source distribution file: dataint-x.x.x_5.5_6.0_src.zip
  * Start Scilab and move to the folder where "builder.sce" resides
  * Execute builder.sce: exec("builder.sce",-1)
  * For temporary use, execute loader.sce. (Does not resist "clear" command)
  * For permanent use, zip the whole folder "dataint" and run atomsInstall

INSTALLATION:
--> atomsInstall("/path/to/dataint_x.x.x_x.x_bin.zip")
or with internet connection
--> atomsInstall("dataint")

DEPENDENCIES:
apifun >= 0.4.0
helptbx (just for the build)

-------------------------------------------------------------------------------