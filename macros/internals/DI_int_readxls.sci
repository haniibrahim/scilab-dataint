function dataMat = DI_int_readxls(fn)
    // ---------------------------------------------------------------------
    // Excel data 
    // ---------------------------------------------------------------------

    // Initial standard values.
    sheetNo   = 1;
    rowRange  = ":";
    colRange  = ":";

    while %T do 
        sheetNo = string(sheetNo); // "values=[]" has to be string matrix even when sheetNo is in "list" declared as "vec"

        // Get some parameters for interpreting the csv file and the name of the output matrix
        labels=["Sheet#"; "Row range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all colums)"];
        datlist=list("vec", 1, "str", 1, "str", 1);
        values=[sheetNo; rowRange; colRange];

        [ok, sheetNo, rowRange, colRange] = getvalue("Parameters", labels, datlist, values);

        if ok == %F then  
            exitID = -2; // canceled parameter box
            return;
        end

        // Simple check input values
        if rowRange == "" then rowRange = ":"; end
        if colRange == "" then colRange = ":"; end
        if isInt(sheetNo) == %F then
            messagebox("Sheet# is not an integer. Try again", "Error", "error", "modal")
            continue;
        else
            break;
        end
    end
    // Read XLS file in matName
    try
        sheets = readxls(fn);
        sheet = sheets(sheetNo);
        sheet = sheet.value; // just the numbers, text is Nan
        execstr( "dataMat = sheet(" + rowRange + "," + colRange + ")");
    catch
        exitID = -3; // Error while interpreting XLS file
        return;
    end
endfunction

