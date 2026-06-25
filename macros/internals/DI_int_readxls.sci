// Copyright (C) 2026 Hani Andreas Ibrahim
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
    // Read XLS/XLSX-Excel data from file
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
    sheetNo    = 1;
    sheetRange = "";

    while %T do 
        sheetNo = string(sheetNo); // "values=[]" has to be string matrix even when sheetNo is in "list" declared as "vec"

        // Get some parameters for interpreting the csv file and the name of the output matrix
        labels=["Sheet no. or name"; "Sheet Range (like A1:C5 or empty for all cells)" ];
        datlist=list("str", 1, "str", 1);
        values=[sheetNo; sheetRange];

        [ok, sheetNo, sheetRange] = getvalue("Parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end

        // check input values
        if sheetRange == "" then
            break;
        elseif ~DI_int_isSheetRange(sheetRange) then
            messagebox(["Sheet Range is not valid."; "Should be like A2:G23" ; "Try again"], "Error", "error","modal");
            continue;
        else
            break;
        end
    end
    
    if sheetNo == "" then
        sheetNo = 1;
    elseif DI_int_isPosInt(sheetNo) then
        sheetNo = strtod(sheetNo);
    end  

    // Read XLS/XLSX file in dataMat
    try
        dataMat = xlread( fn, sheetNo, sheetRange)
    catch
        exitID = -3; // Error while interpreting XLS/XLSX file
        return;
    end
endfunction

