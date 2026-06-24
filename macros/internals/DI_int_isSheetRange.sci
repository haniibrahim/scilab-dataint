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

function result = DI_int_isSheetRange(str)
    
    // -------------------------------------------------------------------------
    // Check if str is a spreadsheet range, like D4:F23
    //
    // Parameters
    // str:    1x1 Stringmatrix, contains the spreadheet range, like "A3:B7"
    // result: 1x1 Boleanmatrix, if "str" is a spreadsheet range
    // -------------------------------------------------------------------------
    
    result = %f;

    // Input must be a string scalar
    if type(str) <> 10 | size(str, "*") <> 1 then
        return;
    end

    col = "(?:[A-W][A-Z]{2}|X[A-E][A-Z]|XF[A-D]|[A-Z]{1,2})";

    pattern = "/^" + col + "[1-9][0-9]*:" + col + "[1-9][0-9]*$/i";

    [start, finish] = regexp(str, pattern, "o");

    result = ~isempty(start) & start == 1 & finish == length(str);
endfunction
