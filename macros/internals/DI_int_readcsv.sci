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

function [dataMat, exitID] = DI_int_readcsv(fn)
    // ---------------------------------------------------------------------
    // Read CSV/TXT data from file
    //
    // Parameters
    // fn:      file path
    // dataMat: matrix with data
    // exitID:   0: Everything is OK. Matrix xlsMat was created
    //          -1: User canceled file selection
    //          -2: User canceled parameter dialog box
    //          -3: Cannot read or interpret file
    //          -4: Cannot interpret file correctly - maybe header present
    // ---------------------------------------------------------------------

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

    // Read CSV file in dataMat
    substitute = ['""',''; '''','']; // Ignore quotes
    try
        // if data file contains blanks as separator
        if fld_sep == ascii(32) then 
            fid1 = mopen(fn, "r");
            dataMat = mgetl(fid1); // Read data as lines of strings in a matrix of strings
            dataMat = dataMat(headernum+1:$,:); // Skip header lines
            mclose(fid1);
            fid2 = mopen(TMPDIR + "/tmp.dat.txt","wt");
            mfprintf(fid2, "%s\n", dataMat); // write header-purged temporary file
            mclose(fid2);
            try
                dataMat=fscanfMat(TMPDIR + "/tmp.dat.txt","%lg"); // read temporary file in matrix variable
            catch
                exitID = -4; 
                errorCleanUp();
                return;
            end
            mdelete(TMPDIR + "/tmp.dat.txt"); // clean up
            // if data file contains NO blanks as separator         
        else 
            // Read from file
            dataMat = csvRead(fn, fld_sep, dec, [], substitute, [], [], headernum);
        end
        // Setup range
        execstr("dataMat = dataMat("+rowRange+","+colRange+");");
    catch
        exitID = -3; // Error while interpreting CSV file
        errorCleanUp();
        return;
    end
endfunction
