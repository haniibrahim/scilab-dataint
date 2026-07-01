dataINT - Toolbox for INTERACTIVE reading and writing of csv- and xls-datafiles
==============================================================================

 dataINT offers functions for convenient, interactive im-/export of test-based 
 data files (*.csv, *.dat, *.txt) or Excel files (*.xls, *.xlsx) to or from a Scilab number 
 matrix, respectively.
 
 dataINT handles:
 - comma separated text data files
 - semicolon separated text data files
 - space separated text data files
 - tabulator separated text data files
 - binary Excel 95-2003 files (*.xls)
 - XML Excel 2010-365 files (*.xlsx)
 
 Parameters, to specify the im-/export, can conveniently entered in a 
 graphic dialog box and the file selection is done by the platform-specific 
 file selection dialog.
 
 You can specify the following im-/export parameters for test data files:
 - Field separator (comma, semicolon, tab, space)
 - Decimal separator (comma, point)
 - Rows and columns you want to import 
 - Number of lines to skip, e.g. header line(s)
 - Comment header line to describe your data 
 
 and for Excel files:
 - Worksheet number or worksheet name
 - Read just cell range or whole worksheet
 - Write numbers to a specified start cell
 
 NEW: dataINT 2.0.0 does handle data from XML-based Excel files (.xlsx), now!
 
 NOTE: dataINT cannot work with Excel's binary *.xlsb files!
 NOTE: dataINT handles doubles only. Non-real-numerical data are imported as NaN.
 
 The functions can easily integrated in your own scripts to make use of 
 dataINT's interactive functionality or to simplify your data import in 
 Scilab's console.
 
 FUNCTIONS:
 
 * DI_read
   Read text numerical data (*.csv, *.dat, *.txt) and Excel (*.xls, *.xlsx) files 
   in a Scilab matrix variable.
 * DI_show
   Read the first 25 or an arbitrary number of lines of a text data file,    
   displays them in the console and invoke the reading procedure after, if
   desired.
 * DI_writedat
   Write comma-separated value (*.csv, *.dat, *.txt) or Excel (*.xls, *.xlsx) 
   files interactively.
 
 dataINT versions are available for Scilab 5.5.x, 6.x, 6.1.x. & 2023, 2024, 2025, 2026 
 Furthermore dataINT is cross-platform.
 
 ---------------------------------------------------------------------
  
 CHANGELOG:
 2.0.0
 - Write binary Excel 95-2003 files (*.xls)
 - Read and write XML Excel 2010-365 files (*.xlsx)
 - Deprecation message displayed for DI_readcsv and DI_readxls. 
   Successor of both is still DI_read with the same API.
 
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

