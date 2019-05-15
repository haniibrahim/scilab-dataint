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

function [csvMat, exitID] = DI_readcsv(path)
    // Imports a CSV file (comma-separated-value) in a matrix variable interactively
    //
    // Calling Sequence
    // [csvMat] = DI_readcsv()
    // [csvMat] = DI_readcsv(path)
    // [csvMat, exitID] = DI_readcsv()
    // [csvMat, exitID] = DI_readcsv(path)
    //
    // Parameters
    // path:   1-by-1 matrix of strings, the path which the file selector points to (OPTIONAL)
    // csvMat: String, Matrix of read numbers from the CSV file (Strings are NaN)
    // exitID:  Exit-ID (0, -1, -2, -3, -4), see below:
    //
    //    0: Everything is OK. Matrix with the name committed in csvMat was created
    //   -1: User canceled file selection
    //   -2: User canceled parameter dialog box
    //   -3: Cannot read or interpret CSV file
    //   -4: Cannot interpret file correctly - maybe header present
    // 
    // Description
    // Read an comma-separated-value (CSV) file interactively. 
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/readcsv_i_import.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // FIELD SEPARATOR: This is the character which separates the fields and 
    // numbers, resp.
    // In general Anglo-Saxon files it is the comma (,), in European files it is  
    // often the semicolon (;). Sometimes it is a tabulator (tab) or a space 
    // (space). E.g. to specify a tabulator as the separator fill in the word 
    // "tab" without quotes.
    //
    // DECIMAL SEPARATOR: The character which indentifies the decimal place. In
    // general Anglo-Saxon files it is the point (.) in most European ones it is  
    // the comma (,).
    //
    // NUMBER OF HEADER LINES TO SKIP: The number of lines to be ignored at the 
    // beginning of the file. This is useful to skip table headers.   
    // 
    // ROW RANGE: The rows you want to select for import. E.g. "2:5" imports
    // rows 2, 3, 4 and 5. "2:$" starts the import at row 2 and imports all 
    // following rows till the last row is reached. ":" means all rows.
    //
    // COLUMN RANGE: The columns you want to select for import. Refer the 
    // description of ROW RANGE above for details.
    //
    // With ROW and COLUMN RANGE you can import a subset of your raw data table 
    // and store the data in a matrix variable for further processing.
    //
    // You can commit an optional path to the function. This is used to open
    // the file selector at the committed target path. If you omit it your home 
    // directory is set as the target path of the file selector box.
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/readcsv.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // The exitID gives a feedback what happened inside the function. If 
    // something went wrong csvMat is always [] (empty). But you can grab an error
    // code in exitID which is always a negative number in an error case (see above). 
    // If the import was sucessfull the exitID is 0.
    //
    // Examples
    // // Open the file selector in the current directory and read the data into
    // // the matrix "mat1". The exit code is stored in the variable "id".
    // [mat1, id] = DI_readcsv(pwd());
    // // Open the file selector in your home directory and read the data into
    // // the matrix "mat2". No exit code is stored.
    // mat2 = DI_readcsv();
    // disp(mat1) // Displays matrix "mat1"
    // disp(mat2) // Displays matrix "mat2"
    //
    // See also
    //  DI_readxls
    //  DI_writecsv
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_readcsv", rhs, 0:1); // Input args
    apifun_checklhs("DI_readcsv", lhs, 1:2); // Output args
    
    function errorCleanUp()
        csvMat = []; 
        mclose("all");
    endfunction

    // init values
    exitID = 0; // All OK
    csvMat = []; // Empty result matrix

    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end

    // Get filename incl. path of an CSV file
    fn=uigetfile(["*.csv|*.txt|*.dat","Data text files (*.csv, *.txt, *.dat)"],path,"Choose a csv-file");
    if fn == "" then
        exitID = -1; // Canceled file selector
        return;
    end

    // Initial standard values.
    fld_sep   = ",";
    dec       = ".";
    headernum = 0;
    rowRange  = ":";
    colRange  = ":";

    while %T do    
        // Get some parameters for interpreting the csv file and the name of the output matrix

        headernum = string(headernum); // "values=[]" has to be string matrix even when headernum is in "list" declared as "vec"

        labels=["Field separator: , | ; | tab | space"; "Decimal separator: . | ,"; "Number of header lines to skip"; "Row Range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all columns)"];
        datlist=list("str", 1, "str", 1, "vec", 1, "str", 1, "str", 1);
        values=[fld_sep; dec; headernum; rowRange; colRange];

        [ok, fld_sep, dec, headernum, rowRange, colRange] = getvalue("CSV and Scilab parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end

        // Simple check input values
        if rowRange == "" then rowRange = ":"; end
        if colRange == "" then colRange = ":"; end
        if fld_sep ~= "," & fld_sep ~= ";" & fld_sep ~= "tab" & fld_sep ~= "space" then
            messagebox("Field delimiter is empty or wrong. Try again", "Error", "error", "modal")
            //fld_sep = ",";
            continue;
        elseif dec ~= "," & dec ~= "." then
            messagebox("Decimal delimiter has the wrong format. Try again", "Error", "error", "modal")
            //dec = ".";
            continue;
        else
            break;
        end
    end

    // Field separator
    if fld_sep == "tab" then 
        fld_sep = ascii(9); // tabulator as separator
    elseif fld_sep == "space" then
        fld_sep = ascii(32); // space as separator
    end

    // Read CSV file in mat_name
    substitute = ['""',''; '''','']; // Ignore quotes
    try
        // if data file contains blanks as separator
        if fld_sep == ascii(32) then 
            fid1 = mopen(fn, "r");
            csvMat = mgetl(fid1); // Read data as lines of strings in a matrix of strings
            csvMat = csvMat(headernum+1:$,:); // Crop header lines
            mclose(fid1);
            fid2 = mopen(TMPDIR + "/tmp.dat.txt","wt");
            mfprintf(fid2, "%s\n", csvMat); // write header-purged temporary file
            mclose(fid2);
            try
                csvMat=fscanfMat(TMPDIR + "/tmp.dat.txt"); // read temporary file in matrix variable
            catch
                exitID = -4; 
                errorCleanUp();
                return;
            end
            mdelete(TMPDIR + "/tmp.dat.txt"); // clean up
            // if data file contains NO blanks as separator         
        else 
            execstr("csvMat = csvRead(fn, fld_sep, dec, [], substitute, [], [], headernum);");
        end
        // Setup range
        execstr("csvMat = csvMat(" + rowRange + "," + colRange + ")");
    catch
        exitID = -3; // Error while interpreting CSV file
        errorCleanUp();
        return;
    end

endfunction

