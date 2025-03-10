dataINT - Toolbox for INTERACTIVE reading and writing of csv- and xls-datafiles
==============================================================================

dataINT offers functions for convenient, interactive im-/export of test-based 
data files (*.csv, *.dat, *.txt) to or from a Scilab matrix or from a binary 
Excel files (*.xls), respectively. 

Parameters, to specify the im-/export, can conveniently entered in a dialog  
box and the file selection is done by the platform-specific 
file selection dialog.

You can specify the following im-/export parameters:
- Field separator (comma, semicolon, tab, space)
- Decimal separator (comma, point)
- Rows and columns you want to import 
- Sheet you want to import 
- Number of lines to skip, e.g. header line(s) 
- Comment header line to describe your data 

IMPORTANT: dataINT does not handle data from XML-based Excel files (.xlsx)!
NOTE: dataINT handles doubles only.

The functions can easily integrated in your own scripts to make use of 
dataINT's interactive functionality or to simplify your data import in 
Scilab's console.

FUNCTIONS:

* DI_read
  Combines functionality of DI_readcsv and DI_readxls in one function
* DI_show
  Read the first 25 or an arbitrary number of lines of a text data file,    
  displays them in the console and invoke the reading procedure after, if
  desired.
* DI_writedat
  Write comma-separated value files (*.csv, *.dat, *.txt) interactively.

dataINT is available for Scilab 2023.0.0 and higher. Furthermore 
dataINT is cross-platform.

-------------------------------------------------------------------------------

CHANGELOG:

 1.2.1
 - Fixed start problems with Atoms on Linux and macOS on newer Scilab versions

1.2.0
- DI_show function added
- DI_writedat replaces DI_writecsv
- Deprecation of DI_readcsv and DI_readxls. Successor of both is DI_read

1.1.1
 - Fix decimal-comma-bug when reading/parsing space separated text files 
   with decimal commas

1.1.0 
- DI_read function introduced
- Better input parameter checking
- Easier input of data ranges for import

1.0.1 Bug fixes: 
- "test" print in DI_readcsv())
- Syntax/Calling Sequence missing bug in help-files
- some minor improvements
   
-------------------------------------------------------------------------------

COMPATIBILITY
Can be build, installed and run with Scilab 5.5.x, 6.0.x and 6.1.x, cross-platform.

BUILD:
  * Decompress the source distribution file: dataint-x.x.x_5.5_6.0_6.1_src.zip
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
