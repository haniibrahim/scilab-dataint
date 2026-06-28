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

function [exitID] = DI_writedat(dataMat, path)
    // Writes numerical data stored in a matrix to a text or Excel file interactively.
    //
    // Syntax
    // [exitID] = DI_writedat(dataMat)
    // [exitID] = DI_writedat(dataMat, path)
    //
    // Parameters
    // dataMat: name of the matrix variable you want to store in a file
    // path: a string, target path for the file selector (OPTIONAL)
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, see below.
    // 
    // Description
    // Write a Scilab matrix of doubles to a CSV or other text-based file or an 
    // Excel file (*.xls, '.xlsx) )interactively.
    //
    // To select the format, specify the corresponding file extension to the file 
    // name. E.g. *.xlsx for XML Excel 2010-365 or *.csv for data text files. 
    // Empty file extentions are not allowed.
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
    //      <term>dataMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which contents the data you want
    // to export.
    //      </para></listitem>
    //  </varlistentry>
    //   <varlistentry>
    //      <term>exitID:</term>
    //      <listitem><para>
    // The exitID gives a feedback what happened inside the function. If 
    // something went wrong dataMat is always [] (empty). To handle errors in a 
    // script you can evaluate exitID's error codes (negative numbers):
    //      </para>
    // <itemizedlist>
    // <listitem><para> 0: Everything is OK. Matrix dataMat was created</para></listitem>
    // <listitem><para>-1: User canceled file selection</para></listitem>
    // <listitem><para>-2: User canceled parameter dialog box</para></listitem>
    // <listitem><para>-3: Cannot write CSV file</para></listitem>
    // <listitem><para>-4: No matrix variable name specified</para></listitem>
    // </itemizedlist>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    // 
    // <title>Export Parameter Text Files</title> 
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
    // <title>Export Parameter Excel Files</title> 
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/writexls.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // <variablelist>
    //  <varlistentry>
    //      <term>Sheet no. or name:</term>
    //      <listitem><para>
    // The number or name of the worksheet of the Excel file you want to export to. 
    // "1" gets to "Sheet 1", "2" to "Sheet 2". The name of sheet should be 
    // committed without quotation marks. If left blank, "Sheet 1" is set.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Start cell:</term>
    //      <listitem><para>
    // Specify a start cell (e.g. D7). All data will be written starting from this 
    // cell. If left blank, the data will start from cell A1. </para>
    // </listitem>
    // </varlistentry>
    // </variablelist>
    //
    // <note>When writing to an existing file, only the specified portion is overwritten. 
    // The entire file is not rewritten, even if the operating system reports that it is.
    // Writing to an existing file is not recommended! </note> 
    //
    //
    // Examples
    // dat = [32.4 34.6 36.5 32.6 ; 102.4 105.0 104.8 102.6];
    // // Open the file selector at the current directory
    // // and write matrix "dat" to the specified Text- or Excel file
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
    
    // Load Internals lib
    libpath = DI_getpath()
    di_internallib  = lib(fullfile(libpath,"macros","internals"))

    [lhs,rhs]=argn()
    apifun_checkrhs("DI_writedat", rhs, 1:2); // Input args
    apifun_checklhs("DI_writedat", lhs, 1);   // Output args
    apifun_checktype("DI_writedat", dataMat, "dataMat", 1, "constant")
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
    while %T do
        fn=uiputfile([ ..
        "*.xls","Excel 95-2003 file (*.xls)"; ..
        "*.xlsx","Excel 2010-365 file (.xlsx)"; ..
        "*.csv|*.dat|*txt","Text data files (*.csv,*.dat,*.txt)"], ..
        path, "Choose a filename to store numerical data")
        // If no file was selected 
        if fn == "" then
            exitID = -1; // Canceled file selector
            return;
        end

        ext = fileparts(fn, "extension"); // file extension
        if  ext ~= "" then
            break;
        end
        messagebox(["No file extension, like .csv, .dat, .txt,", ".xls or .xlsx","Try again"],"Warning", "warning","modal" )
    end

    // Checking data input
    if dataMat == "" then
        exitID = -4; // no matrix name specified => error
        return;
    end

    if ext == ".xls" | ext == ".xlsx" then
        // Excel format --------------------------------------------------------
        // Initial standard values.
        sheetNo    = 1;
        sheetStartCell = "";

        while %T do 
            sheetNo = string(sheetNo); // "values=[]" has to be string matrix

            // Get some parameters for interpreting the csv file and the name of the output matrix
            labels=["Worksheet no. or name"; ..
                    "Start cell (e.g. A8 or blank for A1)" ];
            datlist=list("str", 1, "str", 1);
            values=[sheetNo; sheetStartCell];

            [ok, sheetNo, sheetStartCell] = getvalue("Parameters", labels, datlist, values);

            if ok == %F then  
                exitID = -2; // canceled parameter box
                return;
            end

            // check input values
            if sheetStartCell == "" then
                break;
            elseif ~DI_int_isCell(sheetStartCell) then
                messagebox(["Start cell is not valid."; "Should be like A2" ; "Try again"], ..
                            "Warning", "warning","modal");
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

        // Write XLS/XLSX file in dataMat
        try
           xlwrite( fn, dataMat, sheetNo, sheetStartCell)
        catch
            exitID = -3; // Error while interpreting XLS/XLSX file
            return;
        end
    else
        // Text-based file format ----------------------------------------------
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

        // Write CSV file in dataMat
        try
            if com == "" then // No comment committed
                csvWrite(dataMat, fn, fld_sep, dec);
            else
                csvWrite(dataMat, fn, fld_sep, dec, [], com);
            end
        catch
            exitID = -3; // Error while writing CSV file
            return;
        end
    end
endfunction
