// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
    macros_path = get_absolute_file_path();
    tbx_build_macros(TOOLBOX_NAME, macros_path);
	exec(fullfile(macros_path,"internals","buildmacros.sce")); // build internals
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack

