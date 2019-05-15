// Copyright (C) 2019 Hani Andreas Ibrahim
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, see <http://www.gnu.org/licenses/>.

function [xlsMat, exitID] = DI_readxls(path)
    // Reads a XLS file in a matrix variable interactively
    //
    // Calling Sequence
    // [xlsMat, exitID] = DI_readxls()
    // [xlsMat, exitID] = DI_readxls(path)
    //
    // Parameters
    // path:    Path at which the file selector points to first (OPTIONAL)
    // xlsMath: Matrix of read numbers from the XLS file (Strings are NaN)
    // exitID:  Exit-ID (0, -1, -2, -3, -4), see below:
    //
    //           0: Everything is OK
    //          -1: Canceled file selection
    //          -2: Canceled parameter dialog box
    //          -3: Cannot read or interpret XLS file
    // 
    // Description
    // Read an Excel 97-2003 XLS file interactively. You can specify: 
    //  - number of the sheet in a worksheet file
    //  - row range you want to read
    //  - column range you want to read
    // in a GUI. You can commit a init path for the file selector as an 
    // argument as an option. Otherwise the HOME directory is used.
    //
    // The exitID give a feedback what happened inside the function. If 
    // something went wrog xlsMat is always [] (empty).
    //
    // Examples
    // [xlsMat, exitID] = DI_readxls(pwd()) // Open the file selector in the currend directory
    // xlsMat = DI_readxls()
    //
    // See also
    //  DI_readcsv
    //  DI_writecsv
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_readxls", rhs, 0:1); // Input args
    apifun_checklhs("DI_readxls", lhs, 1:2); // Output args
    inarg = argn(2);
    if inarg > 1 then error(39); end
    
    // init values
    exitID = 0; // All OK
    xlsMat = []; // Empty result matrix

    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end

    // Get filename incl. path of an XLS file
    while %T // Workaround uigetfile()-bug: see below
        fn=uigetfile(["*.xls","Excel 97-2003 Worksheets (*.xls)"],path,"Choose a Excel 97-2003 file (*.xls)")
        if fn == "" then
            exitID = -1; // Canceled file selector
            return;
        end
        // Workaround uigetfile()-bug: Check for not supported Excel files (*.xls-filter accepts xlsx too)
        if part(fn, $-3:$) == ".xls" then
            break;
        else
            messagebox("Wrong Excel file! (xlsx, etc are not supported) Try again!","modal", "error");
        end 
    end
   

    // Get some parameters for interpreting the csv file and the name of the output matrix
    labels=["Sheet#"; "Row range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all colums)"];
    datlist=list("vec", 1, "str", 1, "str", 1);
    values=["1"; ":"; ":"];

    [ok, sheetNo, rowRange, colRange] = getvalue("Parameters", labels, datlist, values);

    if ok == %F then  
        exitID = -2; // canceled parameter box
        return;
    end

    // Read XLS file in matName
    try
        sheets = readxls(fn);
        sheet = sheets(sheetNo);
        execstr( "xlsMat = sheet(" + rowRange + "," + colRange + ")");
    catch
        exitID = -3; // Error while interpreting XLS file
        return;
    end
endfunction
