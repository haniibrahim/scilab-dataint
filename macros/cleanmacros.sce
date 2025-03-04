// ====================================================================
// This file is released under the 3-clause BSD license. See COPYING-BSD.
// ====================================================================
function cleanmacros()

    libpath = get_absolute_file_path();

    binfiles = ls(libpath+"/*.bin");
    for i = 1:size(binfiles,"*")
        mdelete(binfiles(i));
    end

    mdelete(libpath+"/names");
    mdelete(libpath+"/lib");
    exec(fullfile(libpath,"internals","cleanmacros.sce")); // clean internals
endfunction

cleanmacros();
clear cleanmacros; // remove cleanmacros on stack

// ====================================================================
