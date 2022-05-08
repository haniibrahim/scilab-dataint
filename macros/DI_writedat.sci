// Copyright (C) 2022 Hani Andreas Ibrahim
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

function [exitID] = DI_writedat(datMat, path)
    // Exports numerical data stored in a matrix variable to a text data file interactively.
    //
    // Calling Sequence
    // [exitID] = DI_writedat(datMat)
    // [exitID] = DI_writedat(datMat, path)
    //
    // Parameters
    // datMat: name of the matrix variable you want to store in a file
    // path: a string, target path for the file selector (OPTIONAL)
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, see below.
    // 
    // Description
    // Write a Scilab matrix of doubles to a CSV or other text-based file interactively.
    // If you do not specify a file-extension explicitly, ".txt" is added automatically.
    // 
    // <variablelist>
    //  <varlistentry>
    //      <term>path:</term>
    //      <listitem><para>
    // You can commit an optional path to the function. This is used to open
    // the file selector at the committed target path. If you omit it your home 
    // directory is set as the target path.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>datMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which contents the data you want
    // to export.
    //      </para></listitem>
    //  </varlistentry>
    //   <varlistentry>
    //      <term>exitID:</term>
    //      <listitem><para>
    // The exitID gives a feedback what happened inside the function. If 
    // something went wrong datMat is always [] (empty). To handle errors in a 
    // script you can evaluate exitID's error codes (negative numbers):
    //      </para>
    // <itemizedlist>
    // <listitem><para> 0: Everything is OK. Matrix datMat was created</para></listitem>
    // <listitem><para>-1: User canceled file selection</para></listitem>
    // <listitem><para>-2: User canceled parameter dialog box</para></listitem>
    // <listitem><para>-3: Cannot write CSV file</para></listitem>
    // <listitem><para>-4: No matrix variable name specified</para></listitem>
    // </itemizedlist>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    // 
    // Export Parameter: 
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/writecsv.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // <variablelist>
    //  <varlistentry>
    //      <term>Field Separator:</term>
    //      <listitem><para>
    // This is the character which separates the fields and 
    // numbers, resp.
    // In general CSV-files it is the comma (,), in European ones it is  
    // often the semicolon (;). Sometimes it is a tabulator (tab) or a space 
    // (space). E.g. to specify a tabulator as the separator, type in the word 
    // "tab" without quotes.
    //      </para><para>
    // If you select space just ONE space character delimits the data.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Decimal separator:</term>
    //      <listitem><para>
    // The character which identifies the decimal place. In
    // general CSV files it is the point (.), in most European ones it is  
    // the comma (,).
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Comment header:</term>
    //      <listitem><para>
    // Place a comment in the first line/row of the file. This is useful to 
    // describe your data. Just one line is supported (OPTIONAL).
    //      </para></listitem>
    //  </varlistentry>
    // </variablelist>
    //
    // Examples
    // dat = [32.4 34.6 36.5 32.6 ; 102.4 105.0 104.8 102.6];
    // // Open the file selector at the current directory
    // // and write matrix "dat" to the specified csv-file
    // [exitID] = DI_writedat(dat, pwd());
    // disp("Exit-ID: " + string(exitID)) // Displays exit code
    //
    // See also
    //  DI_show
    //  DI_read
    //  csvWrite
    //  csvRead
    //  fscanfMat
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_writedat", rhs, 1:2); // Input args
    apifun_checklhs("DI_writedat", lhs, 1);   // Output args
    apifun_checktype("DI_writedat", datMat, "datMat", 1, "constant")
    if rhs == 2 then
       apifun_checktype("DI_writedat", path, "path", 2,"string"); 
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
    fn=uiputfile(["*.csv|*.dat|*txt","Text data files (*.csv,*.dat,*.txt)"],path,"Choose a filename to store numerical data")
    if fn == "" then
        exitID = -1; // Canceled file selector
        return;
    end
    
    // Checking data input
    if datMat == "" then
        exitID = -4; // no matrix name specified => error
        return;
    end

    // Extension check
    [fnp, fnn, fne] = fileparts(fn);
    if fne == "" then
        fn = fullfile(fnp, fnn + ".txt"); // Add .txt-Extention to a filename if no extension specified
    end
    
    // Get some parameters for interpreting the csv file and the name of the output matrix
    // Initial standard values.
    fld_sep  = ",";
    dec      = ".";
    com      = "";
    
    while %t do
        labels=["Field separator: , | ; | tab | space"; "Decimal separator: . | ,";"Comment header"];
        datlist=list("str", 1, "str", 1, "str", 1);
        values=[fld_sep; dec; com];
        [ok, fld_sep, dec, com] = getvalue("CSV and Scilab parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end
        
        // Checking input values
        if fld_sep ~= "," & fld_sep ~= ";" & fld_sep ~= "tab" & fld_sep ~= "space" then // field separator
            messagebox("Field sparator is empty or wrong. Try again", "Error", "error", "modal")
            //fld_sep = ",";
            continue;
        elseif dec ~= "," & dec ~= "." then// decimal separator
            messagebox("Decimal separator the wrong format. Try again", "Error", "error", "modal")
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
    
    // Write CSV file in datMat
    try
        if com == "" then // No comment committed
            csvWrite(datMat, fn, fld_sep, dec);
        else
            csvWrite(datMat, fn, fld_sep, dec, [], com);
        end
    catch
        exitID = -3; // Error while writing CSV file
        return;
    end

endfunction
