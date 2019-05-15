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

function [exitID] = DI_writecsv(mat_name, path)
    // Write numerical data stored in a matrix in a CSV file interactively
    //
    // Calling Sequence
    // [exitID] = DM_writecsv(mat_name)
    // [exitID] = DM_writecsv(mat_name, path)
    //
    // Parameters
    // mat_name: Character string of the matrix variable you want to store in a csv-file
    // path: Full path at which the file selector points to first (OPTIONAL)
    // exitID: Exit-ID (0, -1, -2, -3, -4), see below:
    //
    //           0: Everything is OK 
    //          -1: Canceled file selection 
    //          -2: Canceled parameter dialog box 
    //          -3: Cannot write CSV file
    //          -4: No matrix name specified 
    // 
    // Description
    // Write a given matrix of doubles to an CSV-file interactively.
    //
    // Examples
    // // Open the file selector at the currend directory
    // // and write matrix "a" to the specified csv-file
    // [exitID] = DI_writecsv("a", pwd())
    // // Open the file selector at your home directory
    // // and write matrix "a" to the specified csv-file
    // DI_writecsv("a");
    //
    // See also
    //  DI_readcsv
    //  DI_readxls
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_writecsv", rhs, 1:2); // Input args
    apifun_checklhs("DI_writecsv", lhs, 1);   // Output args
    apifun_checktype("DI_writecsv", mat_name, "mat_name", 1,"string");
    if rhs == 2 then
       apifun_checktype("DI_writecsv", path, "path", 2,"string"); 
    end

    
    // init values
    exitID = 0; // All OK
    
    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end
    
    // Get filename incl. path of an CSV file
    fn=uiputfile(["*.csv","Comma Separated Value files (*.csv)"],path,"Choose a filename to store numerical data")
    if fn == "" then
        exitID = -1; // Canceled file selector
        return;
    end
    // Extension check
    [fnp, fnn, fne] = fileparts(fn);
    if fne == "" then
        fn = fullfile(fnp, fnn + ".csv"); // Add .csv-Extention to a filename if no extension specified
    end
    
    // Get some parameters for interpreting the csv file and the name of the output matrix
    labels=["Field separator: , | ; | tab | space"; "Decimal separator: . | ,";"Comment header"];
    datlist=list("str", 1, "str", 1, "str", 1);
    values=[","; "."; ""];

    [ok, fld_sep, dec, com] = getvalue("CSV and Scilab parameters", labels, datlist, values);
    
    if ok == %F then  
        exitID = -2; // canceled parameter box
        return;
    end
    //pause;
    // Checking input
    if mat_name == "" then
        exitID = -4; // no matrix name specified => error
        return;
    end
    if fld_sep == "" then
        fld_sep = []; // field separator not specified => Standard field separator "," set
    end
    if dec == "" then
        dec = []; // decimal separator not specified => standard decimal sep. "." set
    end
   
    // Field separator
    if fld_sep == "tab" then 
        fld_sep = ascii(9); // tabulator as separator
    elseif fld_sep == "space" then
        fld_sep = ascii(32); // space as separator
    end
    
    // Write CSV file in mat_name
    try
        if com == "" then // No comment committed
            execstr("csvWrite("+ mat_name + ", fn, fld_sep, dec);");
        else
            execstr("csvWrite(" + mat_name + ", fn, fld_sep, dec, [], com);");
        end
    catch
        exitID = -3; // Error while writing CSV file
        return;
    end

endfunction

