// Copyright (C) 2016 Hani Andreas Ibrahim
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

function dataint_demo()
    
    messagebox("Central England Temperature", "modal","info","Ok");
    aw = messagebox("Import from CSV or XLS-file?", "Data source", "question", ["CSV" "XLS"], "modal")
    
    if aw == 1 then // CSV import
        [dat,id] = DI_readcsv(fullfile(DI_getpath(), "demos"));
        if (id == -1 | id == -2) then // Check for abortion by the user
            messagebox("Aborted by user")
            error("Aborted by user");
            abort;
        elseif id < -2 then // Check for reading errors
            messagebox("Cannot read file")
            error("Cannot read file");
            abort;
        end
    else // XLS import
        [dat,id] = DI_readxls(fullfile(DI_getpath(), "demos"));
        if (id == -1 | id == -2) then 
            messagebox("Aborted by user")
            error("Aborted by user");
            abort;
        elseif id < -2 then
            messagebox("Cannot read file")
            error("Cannot read file");
            abort;
        end
    end
    
    // Display data
    disp(dat)
    
    // Plot data
    plot(dat(:,1),dat(:,14),".")
    xtitle("Central England Temperature","Year","Mean Temperature [°C]")
    
    //
    // Load this script into the editor
    //
    filename = "dataint.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );

endfunction

// Main

dataint_demo();
clear dataint_demo;
