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

function [dataMat, exitID] = DI_read(path)
    // Imports a data file (comma-separated-value, Excel-xls, text-based) in a matrix variable interactively. Combined functionality of DI_readcsv() and DI_readxls().
    //
    // Calling Sequence
    // [dataMat] = DI_read()
    // [dataMat] = DI_read(path)
    // [dataMat, exitID] = DI_read()
    // [dataMat, exitID] = DI_read(path)
    //
    // Parameters
    // path:   a string, target path for the file selector (OPTIONAL)
    // dataMat: a string, name of the matrix which stores the imported data
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, see below.
    //
    // Description
    // Read numerical data from a comma-separated-value (*.csv) or another text-based   
    // data file (*.dat, *.txt) or a binary Excel 95-2003 file (*.xls) and 
    // stores it into a matrix variable interactively.
    //
    // Many field or decimal delimiters in text-based files are accepted (see below).
    //
    // DI_read combines the functionality of DI_readcsv and DI_readxls in one function.
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
    // This is the name of the matrix variable which will content the imported data
    // for further processing in Scilab's console or in a script.
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
    // <listitem><para>-3: Cannot read or interpret data file</para></listitem>
    // <listitem><para>-4: Cannot interpret file correctly - maybe header present (only CSV/TXT data files)</para></listitem>
    // </itemizedlist>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    // 
    // <title>Comma-Separated-Value-, Text-Based Data Files</title>
    // Read text-based data files which contains numerical data. The following 
    // field delimiters are accepted: Comma, semicolon, space(s), tabular(s).
    // The decimal delimiter can be point or comma.
    //
    // <note>
    // Note that the file has to be correctly formated. All rows have to have the
    // same number of columns. 
    // </note>
    // 
    // Import Parameter: 
    //
    // <inlinemediaobject>
    //  <imageobject>
    //      <imagedata fileref="../images/readcsv.png" align="center" valign="middle"/>
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
    // often the semicolon (;). Sometimes it is a tabulator (tab). Text-based
    // data files has a space or spaces as delimiters.
    // E.g. to specify a tabulator as separator, type in the word 
    // "tab", for a space separator the word "space" without quotes.
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
    //      <term>Number of Header Lines to Skip:</term>
    //      <listitem><para>
    // The number of lines to be ignored at the 
    // beginning of the file. This is useful to skip table headers. 
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
    // For CSV and text-based data files there are different prerequisites to 
    // consider.
    //
    // <variablelist>
    //  <varlistentry>
    //      <term>Comma-separated-value (*.csv):</term>
    //      <listitem><para>
    // All rows have to have the same number of columns. That does not mean that 
    // every cell has to be occupied by a number. Only the separator has to be
    // present: 
    //      </para><para>
    //      <screen>
    // 2.3 , 4.4 , 7.6 , 9.5
    // 5.6 , 6.9 ,     ,    
    //      </screen></para><para>
    // Strings or missing data (see above) are represented as Nan (not-a-number)
    // in the matrix. E.g.:
    //      </para><para>
    //      <screen>
    // 2.3  4.4  7.6  9.5
    // 5.6  6.9  Nan  Nan    
    //      </screen></para>
    //      </listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Text-based data (*.dat, *.txt):</term>
    //      <listitem><para>
    // All rows have to have the same number of columns and should not contain 
    // strings (text). Otherwise the data will be imported as a string matrix and
    // not a number matrix.
    //      </para><para>
    //      <screen>
    // | 2.3  4.4  7.6  9.5 |
    // |                    |
    // | 5.6  6.9           |    
    //      </screen></para>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    //
    // <title>Excel 95-2003 Files</title>
    // Read numerical data from XLS-files 
    //
    // <note>
    // DI_read can read binary Excel-files (*.xls) from Excel 95-2003 only. 
    // XML-based Excel files (*.xlsx) from Excel 2010 and higher are not supported!
    // </note>
    //
    // <note>
    // DI_read handles numerical data only. Strings or missing data are imported as 
    // Nan (Not-a-number, %nan).
    // </note>
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
    // [mat, id] = DI_read(fullfile(DI_getpath(), "demos")); // Read CSV file
    // disp("Exit-Code: "+string(id),mat,"data:") // Displays imported data "mat" and exit code "id"
    //
    // See also
    //  DI_readxls
    //  DI_readcsv
    //  DI_writecsv
    //  csvRead
    //  readxls
    //  fscanfMat
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    // Load Internals lib
    path = DI_getpath()
    di_internallib  = lib(fullfile(path,"macros","internals"))


    [lhs,rhs]=argn()
    apifun_checkrhs("DI_read", rhs, 0:1); // Input args
    apifun_checklhs("DI_read", lhs, 1:2); // Output args

    function errorCleanUp()
        dataMat = []; 
        mclose("all");
    endfunction

    // Check for Integer
    function [i] = isInt(n)
        // n: number
        // i: Integer T or F
        if pmodulo(n,1) == 0 then
            i = %T;
        else
            i = %F;
        end
    endfunction


    
    // -------------------------------------------------------------------------

    // init values
    exitID = 0; // All OK
    dataMat = []; // Empty result matrix

    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end

    // -------------------------------------------------------------------------
    // Get filename incl. path of a data file
    // -------------------------------------------------------------------------

    while %T // Workaround uigetfile()-bug: see below
        fn=uigetfile(["*.csv|*.xls|*.txt|*.dat","Data files (*.csv, *.xls, *.txt, *.dat)"],path,"Choose a Data File");
        if fn == "" then
            exitID = -1; // Canceled file selector
            return;
        end
        // Workaround uigetfile()-bug: Check for not supported Excel files (*.xls-filter accepts xlsx, too)
        if fileext(convstr(fn,"l")) == ".xlsx" then
            messagebox("Wrong Excel file! (xlsx, etc are not supported) Try again!","modal", "error");
        else
            break;
        end 
    end

    // -------------------------------------------------------------------------

    // Extract file to lower case converted extension to determine data format (csv/text or xls)
    ext=convstr(fileext(fn), "l");

    // -------------------------------------------------------------------------
    // Process data
    // -------------------------------------------------------------------------

    if ext == ".xls" then
        // Excel data 
        dataMat = DI_int_readxls(fn);
    else
        // CSV/TXT data
        dataMat = DI_int_readcsv(fn);
    end

endfunction

