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

function [exitID] = DI_writecsv(csvMat, path)
    // Exports numerical data stored in a matrix variable to a CSV file interactively
    //
    // Calling Sequence
    // [exitID] = DI_writecsv(csvMat)
    // [exitID] = DI_writecsv(csvMat, path)
    //
    // Parameters
    // csvMat: a string, name of the matrix variable you want to store in a file
    // path: a string, target path for the file selector (OPTIONAL)
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, see below.
    // 
    // Description
    // Write a Scilab matrix of doubles to a CSV or other text-based file interactively.
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
    //      <term>csvMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which contents the data you want
    // to export.
    //      </para></listitem>
    //  </varlistentry>
    //   <varlistentry>
    //      <term>exitID:</term>
    //      <listitem><para>
    // The exitID gives a feedback what happened inside the function. If 
    // something went wrong csvMat is always [] (empty). To handle errors in a 
    // script you can evaluate exitID's error codes (negative numbers):
    //      </para>
    // <itemizedlist>
    // <listitem><para> 0: Everything is OK. Matrix csvMat was created</para></listitem>
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
    // The character which indentifies the decimal place. In
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
    // // Open the file selector at the currend directory
    // // and write matrix "dat" to the specified csv-file
    // [exitID] = DI_writecsv("dat", pwd());
    // disp("Exit-code: " + string(exitID)) // Displays exit code
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
    apifun_checktype("DI_writecsv", csvMat, "csvMat", 1,"string");
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
    if csvMat == "" then
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
    
    // Write CSV file in csvMat
    try
        if com == "" then // No comment committed
            execstr("csvWrite("+ csvMat + ", fn, fld_sep, dec);");
        else
            execstr("csvWrite(" + csvMat + ", fn, fld_sep, dec, [], com);");
        end
    catch
        exitID = -3; // Error while writing CSV file
        return;
    end

endfunction

