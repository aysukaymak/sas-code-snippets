%macro save_as_csv(folder=,table=,caslib);
	filename out filesrvc folderuri=&folder
	filename="&table..csv";
	proc export data=&caslib..&table outfile=out dbms=csv replace;
	run;
%mend save_as_csv;

%macro save_files_as_csv(start=, end=, lib=); *for defining function with default parameters (start=1, end=5,....);
	proc sql;
		select memname into :tables_names separated by ' '
		from dictionary.tables;
		where libname eq "&lib.";
	quit;

	%put &=table_names;
	%do i=&start %to &end;
		%let curr=%scan(table_names, i);
		%put &=curr;		
		%save_as_csv(folder='/folders/folders/@myFolder', table=&curr., caslib=&lib.)
	%end;
%ment save_files_as_csv;
	
save_files_as_csv(start=10, end=15, lib=SASHELP);