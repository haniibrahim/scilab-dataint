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

function [dataMat, exitID] = DI_int_readxls(fn)
            
    // ---------------------------------------------------------------------
    // Read XLS-Excel data from file
    //
    // Parameters
    // fn:      file path
    // dataMat: matrix with data
    // exitID:   0: Everything is OK. Matrix xlsMat was created
    //          -1: User canceled file selection
    //          -2: User canceled parameter dialog box
    //          -3: Cannot read or interpret XLS file
    // ---------------------------------------------------------------------

    // Initial standard values.
    sheetNo   = 1;
    rowRange  = ":";
    colRange  = ":";

    while %T do 
        sheetNo = string(sheetNo); // "values=[]" has to be string matrix even when sheetNo is in "list" declared as "vec"

        // Get some parameters for interpreting the csv file and the name of the output matrix
        labels=["Sheet#"; "Row range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all colums)"];
        datlist=list("vec", 1, "str", 1, "str", 1);
        values=[sheetNo; rowRange; colRange];

        [ok, sheetNo, rowRange, colRange] = getvalue("Parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end

        // Simple check input values
        if rowRange == "" then rowRange = ":"; end
        if colRange == "" then colRange = ":"; end
        if DI_int_isPosInt(sheetNo) == %F then
            messagebox("Sheet# is not an integer. Try again", "Error", "error", "modal")
            continue;
        else
            break;
        end
    end
    // Read XLS file in matName
    try
        sheets = readxls(fn);
        sheet = sheets(sheetNo);
        sheet = sheet.value; // just the numbers, text is Nan
        execstr( "dataMat = sheet(" + rowRange + "," + colRange + ")");
    catch
        exitID = -3; // Error while interpreting XLS file
        return;
    end
endfunction

