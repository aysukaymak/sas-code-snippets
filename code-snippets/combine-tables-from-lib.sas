cas sess;
caslib _all_ assign;
options compress=yes;

%macro list_lib_tables(lib=work, table_cat=);
	%global table_names;
	%let table_names=;
	proc sql;
		select catx('.', 'CASUSER', memname) into :table_names separated by ' '
		from dictionary.tables
		where libname eq "&lib." and memname like "&table_cat.%";
	quit;
	%put &=table_names;
%mend list_lib_tables;

%macro combine_tables(lib=, table_cat=, name=);
	%list_lib_tables(lib=&lib., table_cat=&table_cat.);

	data &lib..&name.;
   		set &table_names. indsname=source;
		dsname = scan(source,2,'.');
	run;
%mend combine_tables;
%combine_tables(lib=CASUSER, table_cat=CONDITION, name=CONDITIONS)
