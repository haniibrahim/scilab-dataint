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
    // Examples
    // [mat, id] = DI_readcsv(fullfile(DI_getpath(), "demos")); // Read CSV file
    // disp("Exit-Code: "+string(id),mat,"data:") // Displays imported data "mat" and exit code "id"
    //
    // See also
    //  DI_readxls
    //  DI_writecsv
    //  csvRead
    //  fscanfMat
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

    // Get filename incl. path of a CSV file
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

    // Read CSV file in csvMat
    substitute = ['""',''; '''','']; // Ignore quotes
    try
        // if data file contains blanks as separator
        if fld_sep == ascii(32) then 
            fid1 = mopen(fn, "r");
            csvMat = mgetl(fid1); // Read data as lines of strings in a matrix of strings
            csvMat = csvMat(headernum+1:$,:); // Skip header lines
            mclose(fid1);
            fid2 = mopen(TMPDIR + "/tmp.dat.txt","wt");
            mfprintf(fid2, "%s\n", csvMat); // write header-purged temporary file
            mclose(fid2);
            try
                csvMat=fscanfMat(TMPDIR + "/tmp.dat.txt","%lg"); // read temporary file in matrix variable
            catch
                exitID = -4; 
                errorCleanUp();
                return;
            end
            mdelete(TMPDIR + "/tmp.dat.txt"); // clean up
        // if data file contains NO blanks as separator         
        else 
            // Read from file
            csvMat = csvRead(fn, fld_sep, dec, [], substitute, [], [], headernum);
        end
        // Setup range
        execstr("csvMat = csvMat("+rowRange+","+colRange+");");
    catch
        exitID = -3; // Error while interpreting CSV file
        errorCleanUp();
        return;
    end

endfunction

