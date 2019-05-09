//
// Scrip which write data (doubles) from the content of a matrix in a CSV-file
//
funcprot(0);

function aborted()
    messagebox("Script aborted by user", "modal", "info");
    disp("Script aborted by user")
    clear ok fld_sep dec mat_name fn home_path com fne values label datlist fnp fnn 
    abort;
endfunction

// Platform-dependent HOME path
if getos() == "Windows" then
    home_path = getenv("USERPROFILE");
else
    home_path = getenv("HOME");
end

// Get filename incl. path of an CSV file
fn=uiputfile(["*.csv","Comma Separated Value files (*.csv)"],home_path,"Choose a filename to store numerical data")
if fn == "" then
    aborted();
end
// Extension check
[fnp, fnn, fne] = fileparts(fn);
if fne == "" then
    fn = fullfile(fnp, fnn + ".csv"); // Add .csv-Extention to a filename if no extension specified
end

// Initial standard values.
fld_sep   = ",";
dec       = ".";
mat_name  = "";
com       = "";

while %T do
    // Get some parameters for interpreting the csv file and the name of the output matrix
    labels=["Name of the Matrix"; "Field separator: , | ; | tab | space"; "Decimal separator: . | ,";"Comment header"];
    datlist=list("str", 1, "str", 1, "str", 1, "str", 1);
    values=[mat_name; fld_sep; dec; com];
    
    [ok, mat_name, fld_sep, dec, com] = getvalue("CSV and Scilab parameters", labels, datlist, values);
    
    if ok == %F then aborted(); end // Cancelled by user
    if mat_name ~= "" & exists(mat_name) then 
        break; 
    else
        messagebox("""Name of the Matrix"" is missing or not existing, try again", "Error", "error", "modal");
    end
end

// Checking input
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
        execstr("csvWrite(" + mat_name + ", fn, fld_sep, dec);");
    else
        execstr("csvWrite(" + mat_name + ", fn, fld_sep, dec, [], com);");
    end
catch
    
end

clear ok fld_sep dec mat_name fn home_path com fne values label datlist fnp fnn 

