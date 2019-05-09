//
// Script which load data (doubles) from an CSV file in a matrix of
// an arbitary name
//
funcprot(0);

function aborted()
    messagebox("Script aborted by user", "modal", "info");
    abort;
endfunction

function errorCleanUp()
    mdelete(TMPDIR + "/tmp.dat.txt");
    csvMat = [];
    mclose("all");
endfunction

// Platform-dependent HOME path
if getos() == "Windows" then
    home_path = getenv("USERPROFILE");
else
    home_path = getenv("HOME");
end

// Get filename incl. path of an CSV file
fn=uigetfile(["*.csv|*.txt|*.dat","Data text files (*.csv, *.txt, *.dat)"],home_path,"Choose a csv-file");
if fn == "" then
    disp("Script aborted by user")
    clear ok fld_sep dec headernum mat_name values datlist fn home_path rowRange colRange csvMat fid1 fid2 substitute labels fn home_path
    aborted();
end

// Initial standard values.
fld_sep   = ",";
dec       = ".";
headernum = 0;
rowRange  = ":";
colRange  = ":";
mat_name  = "mat";

while %T do
    headernum = string(headernum); // "values=[]" has to be string matrix even when headernum is in "list" declared as "vec"
    // Get some parameters for interpreting the csv file and the name of the output matrix
    labels=["Field delimiter: , | ; | tab | space"; "Decimal delimiter: . | ,"; "Number of header lines to skip"; "Row Range, e.g. 2:5 (2nd to 5th row) or 2 (2nd row only) or : (all rows)"; "Column range, e.g. 1:3 (1st to 3rd col.) or 2 (2nd col. only) or : (all columns)"; "Name of matrix where Scilab saves the data"];
    datlist=list("str", 1, "str", 1, "vec", 1, "str", 1, "str", 1, "str", 1);
    values=[fld_sep; dec; headernum; rowRange; colRange; mat_name]; // variables instead of values because keeping entered values in case of error

    [ok, fld_sep, dec, headernum, rowRange, colRange, mat_name] = getvalue("CSV and Scilab parameters", labels, datlist, values);

    if ok == %F then
        disp("Script aborted by user")
        clear ok fld_sep dec headernum mat_name values datlist fn home_path rowRange colRange csvMat fid1 fid2 substitute labels fn home_path  
        aborted();
    end

    // Simple check input values
    if rowRange == "" then rowRange = ":"; end
    if colRange == "" then colRange = ":"; end
    if fld_sep ~= "," & fld_sep ~= ";" & fld_sep ~= "tab" & fld_sep ~= "space" then
        messagebox("Field delimiter is empty. Try again", "Error", "error", "modal")
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

// Field delimiter
if fld_sep == "tab" then 
    fld_sep = ascii(9); // tabulator as delimiter
elseif fld_sep == "space" then
    fld_sep = ascii(32); // space as delimiter
end

// Read CSV file in mat_name
substitute = ['""',''; '''','']; // Ignore quotes
try
    // if data file contains blanks as separator
    if fld_sep == ascii(32) then 
        fid1 = mopen(fn, "rt");
        csvMat = mgetl(fid1); // Read data as lines of strings in a matrix of strings
        csvMat = csvMat(headernum+1:$,:); // Crop header lines
        mclose(fid1);
        fid2 = mopen(TMPDIR + "/tmp.dat.txt","wt");
        mfprintf(fid2, "%s\n", csvMat); // write header-purged temporary file
        mclose(fid2);
        try
            csvMat=fscanfMat(TMPDIR + "/tmp.dat.txt"); // read temporary file in matrix variable
        catch
            messagebox(["Cannot interpret file " + fn + "." "Maybe header is still present"], "modal", "error");
            disp("Cannot interpret file" + fn +". Maybe header still present");
            disp("Script aborted by user")
            clear ok fld_sep dec headernum mat_name values datlist fn home_path rowRange colRange csvMat fid1 fid2 substitute labels fn home_path
            errorCleanUp();
        end
        execstr(mat_name + "= csvMat");
        mdelete(TMPDIR + "/tmp.dat.txt"); // clean up
        // if data file contains NO blanks as separator         
    else 
        //        execstr("csvMat = csvRead(fn, fld_sep, dec, [], substitute, [], [], headernum);");
        execstr(mat_name + " = csvRead(fn, fld_sep, dec, [], substitute, [], [], headernum);");
    end
    // Apply range
    execstr(mat_name + "=" + mat_name + "(" + rowRange + "," + colRange + ");");
catch
    messagebox("Cannot read file " + fn, "modal", "error");
    disp("Cannot read CSV-file " + fn);
    disp("Script aborted by user")
    clear ok fld_sep dec headernum mat_name values datlist fn home_path rowRange colRange csvMat fid1 fid2 substitute labels fn home_path
    errorCleanUp();
end

// Message where to find the read data
messagebox("Data loaded in matrix: " + mat_name, "modal", "info");
disp("Data of csv-file " + fn + " is loaded in matrix: " + mat_name);

// Screen output of loaded csv file
//execstr("disp(" + mat_name + ")") 

clear ok fld_sep dec headernum mat_name values datlist fn home_path rowRange colRange csvMat fid1 fid2 substitute labels fn home_path
mclose("all");
