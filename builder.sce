// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1);
lines(0);

function main_builder()
    TOOLBOX_NAME  = "dataint";
    TOOLBOX_TITLE = "dataINT";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab-Version
    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.5 or higher is required."));
    end

    if v(1) < 2023  then 
        error(gettext("Scilab 2023.0.0 or higher is required."));
    end

    // Action ----------------------------------------------------------------------

    // Update help XML-files from sci-files via Helptbx
    exec(fullfile(toolbox_dir,"/help/en_US/update_help.sce"),-1);
    
    // =============================================================================

    tbx_builder_macros(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(toolbox_dir);
    tbx_build_cleaner(toolbox_dir);

endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


