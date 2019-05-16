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
    // Imports a binary Excel file (xls) in a matrix variable interactively
    //
    // Calling Sequence
    // [xlsMat] = DI_readxls()
    // [xlsMat] = DI_readxls(path)
    // [xlsMat, exitID] = DI_readxls()
    // [xlsMat, exitID] = DI_readxls(path)
    //
    // Parameters
    // path:   a string, target path for the file selector (OPTIONAL)
    // xlsMat: a string, name of the matrix which stores the imported data
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3=error codes, see below.
    // 
    // Description
    // Read data from a binary Excel 95-2003 file (*.xls) and stores it into 
    // a matrix variable interactively.
    //
    // <note>
    // DI_readxls does not handle data from XML-based Excel files (*.xlsx) of 
    // Excel 2007 and higher!
    // </note>
    //
    // <note>
    // DI_readxls handles doubles only. Strings or missing data are imported as 
    // Nan (Not-a-number, %nan).
    // </note>
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
    //      <term>xlsMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which contents the imported data
    // for further processing in Scilab's console or in a script.
    //      </para></listitem>
    //  </varlistentry>
    //   <varlistentry>
    //      <term>exitID:</term>
    //      <listitem><para>
    // The exitID gives a feedback what happened inside the function. If 
    // something went wrong xlsMat is always [] (empty). To handle errors in a 
    // script you can evaluate exitID's error codes (negative numbers):
    //      </para>
    // <itemizedlist>
    // <listitem><para> 0: Everything is OK. Matrix xlsMat was created</para></listitem>
    // <listitem><para>-1: User canceled file selection</para></listitem>
    // <listitem><para>-2: User canceled parameter dialog box</para></listitem>
    // <listitem><para>-3: Cannot read or interpret XLS file</para></listitem>
    // </itemizedlist>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    // 
    // Import Parameter: 
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/readxls.png" align="center" valign="middle"/>
    //  </imageobject>
    // </inlinemediaobject>
    //
    // <variablelist>
    //  <varlistentry>
    //      <term>Sheet#:</term>
    //      <listitem><para>
    // The number of the sheet of the Excel file you want to import from. The 
    // names of the sheets are not evaluated. The 1st sheet is 1 the 2nd is 2
    // independent of their names in Excel.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Row Range:</term>
    //      <listitem><para>
    // The rows you want to select for import. E.g. "2:5" imports
    // rows 2, 3, 4 and 5. "2:$" starts the import at row 2 and imports all 
    // following rows till the last row is reached. ":" means all rows.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Column Range:</term>
    //      <listitem><para>
    // The columns you want to select for import. Refer the 
    // description of "row range" above for details.
    //      </para>
    //      <para>
    // With row and column range you can import a subset of your raw data table 
    // for further processing. 
    //      </para></listitem>
    //  </varlistentry>
    // </variablelist>
    //
    // Examples
    // [mat, id] = DI_readxls(fullfile(DI_getpath(), "demos")) // Read XLS file
    // disp("Exit-Code: "+string(id),mat,"data:") // Displays imported data "mat" and exit code "id"
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
        sheet = sheet.value; // just the numbers, text is Nan
        execstr( "xlsMat = sheet(" + rowRange + "," + colRange + ")");
    catch
        exitID = -3; // Error while interpreting XLS file
        return;
    end
endfunction
