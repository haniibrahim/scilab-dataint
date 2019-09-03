// Copyright (C) 2019 Hani Andreas Ibrahim
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

function i = DI_int_isPosInt(n)
   
    // ---------------------------------------------------------------------
    // Check for positive integer >= 1
    //
    // Parameters
    // n: n-by-m  matrix of any kind
    // i: integer or not - n-by-m matrix of binaries
    // ---------------------------------------------------------------------
    
    if pmodulo(n,1)==0 & n>0 then
        i = %T;
    else
        i = %F;
    end
endfunction
