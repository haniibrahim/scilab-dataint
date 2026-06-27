// Copyright (C) 2026 Hani Andreas Ibrahim
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

function result = DI_int_isCell(str)
    // -------------------------------------------------------------------------
    // Check if str is a spreadsheet cell name, like D4
    //
    // Parameters
    // str:    1x1 string matrix 
    // result: 1x1 boolean matrix, 
    //         %T = str contains Excel cell name, like A4
    //         %F = str doesn't contain Excel cell name
    
    result = %F;

    if type(str) <> 10 then
        return;
    end

    str = convstr(str, "u");

    // Test: Chars followed by a positive number
    r = regexp(str, "/^[A-Z]+[1-9][0-9]*$/");

    if r == [] then
        return;
    end

    // Find the position of the first number
    i = regexp(str, "/[0-9]/");

    if i == [] then
        return;
    end

    col = part(str, 1:i(1)-1);
    row = evstr(part(str, i(1):length(str)));

    // Calculate column number (A=1, B=2 ... Z=26, AA=27)
    c = 0;
    for k = 1:length(col)
        c = c*26 + ascii(part(col,k)) - ascii("A") + 1;
    end

    // Check Excel Limits
    if (c >= 1) & (c <= 16384) & (row >= 1) & (row <= 1048576) then
        result = %T;
    end

endfunction
