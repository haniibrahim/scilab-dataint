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
    
    // init values
    exitID = 0; // All OK
    dataMat = []; // Empty result matrix

    // Initial standard values.
    sheetNo  = 1;
    rowStart = "1";
    rowEnd   = "$";
    colStart = "1";
    colEnd   = "$";

    while %T do 
        sheetNo = string(sheetNo); // "values=[]" has to be string matrix even when sheetNo is in "list" declared as "vec"

        // Get some parameters for interpreting the csv file and the name of the output matrix
        labels=["Sheet#"; "Row range start";"Row range end ($=end of row)"; "Column range start"; "Column range end ($=end of column)" ];
        datlist=list("vec", 1, "str", 1, "str", 1, "str", 1, "str", 1);
        values=[sheetNo; rowStart; rowEnd; colStart; rowEnd];

        [ok, sheetNo, rowStart, rowEnd, colStart, colEnd] = getvalue("Parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end

        // check input values
        if ~isnum(string(sheetNo)) | ~DI_int_isPosInt(sheetNo) then
            messagebox("Sheet# is not an integer. Try again", "Error", "error", "modal")
            continue;
        elseif ~isnum(rowStart) | ~DI_int_isPosInt(strtod(rowStart)) then
            messagebox("Row range start is empty or wrong. Type in number, e.g. 1. Try again", "Error", "error", "modal");
            continue;
        elseif ~isnum(colStart) & ~DI_int_isPosInt(strtod(colStart)) then
            messagebox("Column range start is empty or wrong. Type in number, e.g. 1. Try again", "Error", "error", "modal");
            continue;
        elseif ~DI_int_isPosInt(strtod(rowEnd)) & ~(strtod(rowEnd)>0) & string(rowEnd)~="$" then
            messagebox("Row range end is empty or wrong. Type in number or $. Try again", "Error", "error", "modal");
            continue;
        elseif ~DI_int_isPosInt(strtod(colEnd)) & ~(strtod(colEnd)>0) & string(colEnd)~="$" then
            messagebox("Column range end is empty or wrong. Type in number or $. Try again", "Error", "error", "modal");
            continue;
        else
            break;
        end
    end
    
    // Merge ranges
    rowRange = rowStart + ":" + rowEnd; // e.g. 1:$
    colRange = colStart + ":" + colEnd; // e.g. 1:$
    
    // Read XLS file in dataMat
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

