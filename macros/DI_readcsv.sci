function [csvMat, exitID] = DI_readcsv(path)
    //
    // Reads a CSV file in a matrix variable interactively
    //
    // CALLING SEQUENCES
    // [csvMat, exitID] = DI_readcsv(path)
    // [csvMat, exitID] = DI_readcsv()
    //
    // PARAMETERS
    // path:    Path at which the file selector points to first (OPTIONAL)
    //          If not commited the HOME/USERPROFILE directory is used
    // csvMath: Matrix of read numbers from the CSV file (Strings are NaN)
    // exitID:  Exit#
    //           0: Everything is OK
    //          -1: Canceled file selection
    //          -2: Canceled parameter dialog box
    //          -3: Cannot read or interpret CSV file
    //          -4: Cannot interpret file correctly - maybe header present
    // 
    // DESCRIPTION
    // Read an comma-separated-value (CSV) file interactively. You can specify: 
    //  - number of the sheet in a worksheet file
    //  - row range you want to read
    //  - column range you want to read
    // in a GUI. You can commit a init path for the file selector as an 
    // argument as an option. Otherwise the HOME directory is used.
    //
    // The exitID give a feedback what happened inside the function. If 
    // something went wrog csvMat is always [] (empty).
    //
    // EXAMPLES
    // [csvMat, exitID] = DI_readcsv(pwd()) // Open the file selector in the currend directory
    // csvMat = DI_readcsv()
    //
    
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

