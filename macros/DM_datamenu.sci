function []=DM_datamenu(action)
    [lhs,rhs]=argn();
	
	path = DM_getpath();
    
	// Menu actions
    if (rhs==1) & (typeof(action)=='constant') then
        if action == 1 then
            exec(fullfile(path,"macros","sce", "ReadCsv.sce"),-1);
        end
        if action == 2 then
            exec(fullfile(path,"macros","sce", "ReadXls.sce"),-1);
        end
        if action == 3 then
            exec(fullfile(path,"macros","sce", "WriteCsv.sce"),-1);
        end
    end
	
    // Initialize menu & menu-related functions
    if (rhs==1) & (typeof(action)=='string') & (action=='start') then 
        addmenu('Data',["Load *.csv","Load *.xls", "Save *.csv"],list(2,"DM_datamenu"));
    end
    if (rhs==1) & (typeof(action)=='string') & (action=='quit') then 
        delmenu("Data");
    end
endfunction
