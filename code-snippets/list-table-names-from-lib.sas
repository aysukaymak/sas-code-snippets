%macro list_lib_tables(lib=work);
	%global table_names;
	%let table_names=;
	proc sql;
		select memname into :table_names separated by ' '
		from dictionary.tables
		where libname eq "&lib.";
	quit;
	%put &=table_names;
%mend;

%list_lib_tables(lib=CASUSER)
