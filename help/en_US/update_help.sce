cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
// Generate the root help
mprintf("Updating root\n");
helpdir = fullfile(cwd);
funmat = [
  "DM_readcsv"
  "DM_readxls"
  "DM_writecsv"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "xxx";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
// ========================================================================================
// Generate the utilities help
mprintf("Updating utilities\n");
helpdir = fullfile(cwd,"utilities");
funmat = [
  "DM_getpath"
  "DM_datamenu"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "xxx";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );

