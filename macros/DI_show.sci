2// Copyright (C) 2019 Hani Andreas Ibrahim
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

function [dataMat, exitID] = DI_show(path, n)
    // Read and display the first 25 or an arbitrary number of lines of a text data file.
    //
    // Syntax
    // [dataMat] = DI_show()
    // [dataMat] = DI_show(path)
    // [dataMat] = DI_show(path, n)
    // [dataMat] = DI_show(,n)
    // [dataMat, exitID] = DI_show()
    // [dataMat, exitID] = DI_show(path)
    // [dataMat, exitID] = DI_show(path, n)
    // [dataMat, exitID] = DI_show(, n)
    //
    // Parameters
    // path:    string, target path for the file selector (OPTIONAL)
    // n:       integer, Number of lines to display (OPTINAL), default: 25
    // dataMat: string, name of the matrix which stores the imported data, if confirmed, default: ans, IMPORTANT: See note below.
    // exitID:  integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, if data reading was confirmed. IMPORTANT: See note below.
    //
    // <note>
    // Output args, dataMat und exidID, are only available when reading procedure was confirmed in the GUI. It will
    // call DI_read() in the background.
    // </note>
    //
    // Description
    // Read the first 25 or an arbitrary number of lines of a text-based data file and 
    // displays them in the console for reviewing data, determine delimiter signs, 
    // comment lines etc. This makes it easier to fill in the right paramezters for 
    // reading procedures, as DI_read().
    //
    // In the GUI the user will be prompted whether he or she wants to load the data 
    // into a matrix variable after the preview was displayed. If the user committed
    // the question the reading procedure DI_read() will be called in the background.
    // 
    // <variablelist>
    //  <varlistentry>
    //      <term>path:</term>
    //      <listitem><para>
    // You can commit an optional target path to the function. This is used to 
    // open the file selector at the committed target path. If you omit it your home 
    // directory is set as the target path.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>n:</term>
    //      <listitem><para>
    // You can commit an optional number of lines to display. If you do not specify N
    // 25 lines will be displayed by default. 
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>dataMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which will contain the imported data
    // for further processing in Scilab's console or in a script. It is available
    // when you confirm data reading in the GUI only.
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
    //      <para>
    //  They will be available when you confirm data reading in the GUI only.
    //      </para>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
    // 
    // <title>Comma-Separated-Value-, Text-Based Data Files</title>
    //
    // <note>
    // Only available if reading was confirmed in the GUI.
    // </note>
    //
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
    // The character which identifies the decimal place. In
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
    //      <term>Row/Columns Range Start:</term>
    //      <listitem><para>
    // The row/column at which the import is going to start. Type a number. 1 means 
    // import starts at row/column 1 inclusively.
    //      </para></listitem>
    //  </varlistentry>
    //  <varlistentry>
    //      <term>Row/Columns Range End:</term>
    //      <listitem><para>
    // The row at which the import is going to end. Type a number or $ (dollar-
    // sign). 12 means the import stops at row 12 inclusively, $ means that all 
    // rows/columns are read to the end.
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
    // Examples
    // [mat, id] = DI_show(fullfile(DI_getpath(), "demos"),10);
    // if id == 0 & mat ~= [] then // Plot data if import was successful
    //    plot(mat(:,1),mat(:,14),"-")
    //    xtitle("Central England Temperature","Year","Mean Temperature [°C]")
    // else
    //    mprintf("Reading of data not confirmed\n")
    // end
    //
    // See also
    //  DI_read
    //  DI_writedat
    //  csvRead
    //  fscanfMat
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    // Load Internals lib
    libpath = DI_getpath()
    di_internallib  = lib(fullfile(libpath,"macros","internals"))

    // Support functions --------------------------------------------------------

    // File handling clean up
    function errorCleanUp()
        mclose("all");
    endfunction

    // Check for integer > 0
    function i = isInt(n)
        if pmodulo(n,1) == 0 & n==0 then
            i = %T;
        else
            i = %F;
        end
    endfunction

    // -------------------------------------------------------------------------

    // Check for input and output options
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_show", rhs, 0:2); // Input args => 0 to 2
    apifun_checklhs("DI_show", lhs, 0:2); // Output args => 0 to 2

    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end


    // Set default number of diplayed lines, if n ist not committed
    if ~exists("n") then
        n = 25;
    elseif isInt(n) then
        messagebox("n is not a number or <= 0. Type in number, e.g. 30. Try again", "Error", "error", "modal");
    end

    // Init values
    exitID  = 0;  // All OK
    rows    = []; // No. of rows read
    dataMat = []; // Matrx von Data if reading data was desired

    // Get file name
    fn=uigetfile(["*.csv|*.txt|*.dat","Data files (*.csv, *.txt, *.dat)"],path,"Choose a Text-Data File");
    if fn == "" then
//        exitID = -1; // Canceled file selector
        messagebox("Canceled file selector", "Canceled", "error", "modal");
        return;
    end

    // Read first lines of the data file
    try
        fid1 = mopen(fn, "r");
        rows = mgetl(fid1, n); // Read n lines of the file in a matrix of strings
        mclose(fid1);
    catch
//        exitID = -3; // Error while interpreting CSV file
        messagebox("Error while reading file", "Error", "error", "modal");
        errorCleanUp();
        return;
    end
    
    // Display rows of the file ------------------------------------------------
    
    // Prevent the display loop from overflowing if n > rows 
    lrows = size(rows,1); // No. of rows
    if n > lrows then
        n = lrows
    end

    mprintf( ..
    " First %i rows of the file: %s\n\n", ..
    n, fn)
    
    mprintf(.. 
    " No.| Data\n" + ..
    "--------------------------------------------------------------------------\n" ..
    )
    for i=1:n
        mprintf("%3i | %s\n", i, rows(i));
    end
    
    // Go to DI_read directly?
    aw = messagebox("Do you want to read data now?", "Read data?", "question", ["Yes" "No"], "modal")
    if aw == 1 then // yes
        [dataMat, exitID] = DI_int_readcsv(fn);
    end
   
    return 

endfunction
