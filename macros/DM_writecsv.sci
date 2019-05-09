function [exitID] = DM_writecsv(mat_name, path)
    //
    // Write numerical data stored in a matrix in a CSV file interactively
    //
    // CALLING SEQUENCES
    // [exitID] = DM_writecsv(mat_name, path)
    // [exitID] = DM_writecsv(mat_name)
    //
    // PARAMETERS
    // mat_name:Character string of the matrix variable you want to store in a csv-file
    // path:    Full path at which the file selector points to first (OPTIONAL)
    //          If not commited the HOME/USERPROFILE directory is used
    // exitID:  Exit#
    //           0: Everything is OK 
    //          -1: Canceled file selection 
    //          -2: Canceled parameter dialog box 
    //          -3: Cannot write CSV file 
    //          -4: No matrix name specified 
    // 
    // DESCRIPTION
    // Write a given numerical matrix to an CSV-file interactively. 
    //
    // EXAMPLES
    // [exitID] = DM_writecsv("a", pwd()) // Open the file selector in the currend directory
    // DM_writecsv("a");
    //
    
    [lhs,rhs]=argn()
    apifun_checkrhs("DM_writecsv", rhs, 1:2); // Input args
    apifun_checklhs("DM_writecsv", lhs, 1);   // Output args
    apifun_checktype("DM_writecsv", mat_name, "mat_name", 1,"string");
    if rhs == 2 then
       apifun_checktype("DM_writecsv", path, "path", 2,"string"); 
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
    if mat_name == "" then
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
    
    // Write CSV file in mat_name
    try
        if com == "" then // No comment committed
            execstr("csvWrite("+ mat_name + ", fn, fld_sep, dec);");
        else
            execstr("csvWrite(" + mat_name + ", fn, fld_sep, dec, [], com);");
        end
    catch
        exitID = -3; // Error while writing CSV file
        return;
    end

endfunction

