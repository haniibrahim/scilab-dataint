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

function show_demo()
    
    messagebox(["Central England Temperature";"DI_show Demo, preview text-based data and read data"], "modal","info","Ok");
    
    [dat,id] = DI_show(get_absolute_file_path("show.dem.sce"),10); // Show the first 10 lines of the data file
        if (id == -1 | id == -2) then // Check for abortion by the user
            messagebox("Aborted by user")
            disp("Aborted by user");
            abort;
        elseif id < -2 then // Check for reading errors
            messagebox("Cannot read file")
            disp("Cannot read file");
            abort;
        end
    
    // Display and plot data if available
    if dat ~= [] then
		disp(dat)    
        plot(dat(:,1),dat(:,14),"-")
        xtitle("Central England Temperature","Year","Mean Temperature [°C]")
	end
    
    //
    // Load this script into the editor
    //
    filename = "show.dem.sce";
    dname = get_absolute_file_path(filename);
    editor ( fullfile(dname,filename) );

endfunction

// Main

show_demo();
clear show_demo;
