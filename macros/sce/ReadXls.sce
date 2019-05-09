//
// Script which load data (doubles) from an XLS file in a matrix of
// an arbitary name
//
funcprot(0);
function aborted()
    messagebox("Script aborted by user", "modal", "info");
    disp("Script aborted by user")
    abort;
endfunction

// Platform-dependent HOME path
if getos() == "Windows" then
    home_path = getenv("USERPROFILE");
else
    home_path = getenv("HOME");
end

// Get filename incl. path of an XLS file
while %T // Workaround uigetfile()-bug: see below
    fn=uigetfile(["*.xls","Excel 97-2003 Worksheets (*.xls)"],home_path,"Choose a Excel 97-2003 file (*.xls)")
    if fn == "" then
        aborted();
    end
    // Workaround uigetfile()-bug: Check for not supported Excel files (*.xls-filter accepts xlsx too)
    if part(fn, $-3:$) == ".xls" then
        break;
    else
        messagebox("Wrong Excel file! (xlsx, etc are not supported) Try again!","modal", "error");
    end 
end


// Get some parameters for interpreting the csv file and the name of the output matrix
labels=["Sheet#"; "Row range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all colums)"; "Name of output matrix for Scilab"];
dat=list("vec", 1, "str", 1, "str", 1, "str", 1);
values=["1"; ":"; ":"; "mat"];

[ok, sheetNo, rowRange, colRange, matName] = getvalue("Parameters", labels, dat, values);

if ok == %F then  
    aborted();
end

// Read XLS file in matName
try
    sheets = readxls(fn);
    sheet = sheets(sheetNo);
    execstr( matName + " = sheet(" + rowRange + "," + colRange + ")");
catch
    messagebox("Cannot read file " + fn, "modal", "error");
    disp("Cannot read xls-file " + fn);
    lasterror
    abort;
end


// Message where to find the read data
messagebox("Data loaded in matrix: " + matName, "modal", "info");
disp("Data of csv-file " + fn + " is loaded in matrix: " + matName);

// Screen output of loaded csv file
//execstr("disp(" + matName + ")")

// Clean up
clear ok sheetNo rowRange colRange matName labels dat values sheets sheet fn home_path;
