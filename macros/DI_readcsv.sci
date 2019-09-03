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
    // path:   a string, target path for the file selector (OPTIONAL)
    // csvMat: a string, name of the matrix which stores the imported data
    // exitID: an integer, exit codes, 0=OK, -1, -2, -3, -4=error codes, see below.
    //
    // Description
    // Read numerical data from a comma-separated-value (*.csv) or another text-based   
    // data file (*.dat, *.txt) and stores it into a matrix variable interactively.
    //
    // The following field delimiters are accepted: Comma, semicolon, space(s), 
    // tabular(s). The decimal delimiter can be point or comma.
    //
    // <note>
    // Note that the file has to be correctly formated. All rows have to have the
    // same number of columns. 
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
    //      <term>csvMat:</term>
    //      <listitem><para>
    // This is the name of the matrix variable which will content the imported data
    // for further processing in Scilab's console or in a script.
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
    // <listitem><para>-3: Cannot read or interpret CSV file</para></listitem>
    // <listitem><para>-4: Cannot interpret file correctly - maybe header present</para></listitem>
    // </itemizedlist>
    //      </listitem>
    //  </varlistentry>
    // </variablelist>
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
    // <title>Prerequisites to consider</title>
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
    // [mat, id] = DI_readcsv(fullfile(DI_getpath(), "demos")); // Read CSV file
    // disp("Exit-ID: "+string(id),mat,"data:") // Displays imported data "mat" and exit code "id"
    // if id == 0 then // Plot data if import was sucessful
    //    plot(mat(:,1),mat(:,14),".-")
    //    xtitle("Central England Temperature","Year","Mean Temperature [°C]")
    // end  
    //
    // See also
    //  DI_readxls
    //  DI_writecsv
    //  csvRead
    //  fscanfMat
    //
    // Authors
    //  Hani A. Ibrahim - hani.ibrahim@gmx.de
    
    // Load Internals lib
    libpath = DI_getpath()
    di_internallib  = lib(fullfile(libpath,"macros","internals"))
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DI_readcsv", rhs, 0:1); // Input args
    apifun_checklhs("DI_readcsv", lhs, 1:2); // Output args
    
    // Platform-dependent HOME path if "path" was not commited
    if ~exists("path") then
        if getos() == "Windows" then
            path = getenv("USERPROFILE");
        else // Unix, GNU/Linux, macOS
            path = getenv("HOME");
        end
    end

    // Get filename incl. path of a CSV file
    fn=uigetfile(["*.csv|*.txt|*.dat","Data text files (*.csv, *.txt, *.dat)"],path,"Choose a csv-file");
    if fn == "" then
        exitID = -1; // Canceled file selector
        csvMat= [];
        return;
    end

    [csvMat, exitID] = DI_int_readcsv(fn);

endfunction

