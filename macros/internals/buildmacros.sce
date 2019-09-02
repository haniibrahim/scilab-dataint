function buildInternal()
	path = get_absolute_file_path("buildmacros.sce")
	genlib("di_internallib",path,%f,%t);
endfunction

buildInternal();
clear buildInternal;
