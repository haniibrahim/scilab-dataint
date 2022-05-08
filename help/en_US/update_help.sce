cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
// Generate the root help
mprintf("Updating root\n");
helpdir = fullfile(cwd);
funmat = [
  "DI_read"
  "DI_show"
  "DI_writedat"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "dataint";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
// ========================================================================================
// Generate the utilities help
mprintf("Updating utilities\n");
helpdir = fullfile(cwd,"utilities");
funmat = [
  "DI_getpath"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "dataint";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
// ========================================================================================
// Generate the deprecated help
mprintf("Updating deprecated\n");
helpdir = fullfile(cwd,"deprecated");
funmat = [
  "DI_readcsv"
  "DI_readxls"
  "DI_writecsv"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "dataint";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
