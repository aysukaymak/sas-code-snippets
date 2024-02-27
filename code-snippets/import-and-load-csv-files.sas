cas impsess;
caslib _all_ assign;
options compress=yes;

*import specific table;
%macro import_tables(path=, table=, lib=);
	proc sql;
		%if %sysfunc(exist(&lib..&table.)) %then
			%do;
				drop table &lib..&table.;
			%end;

		%if %sysfunc(exist(&lib..&table., VIEW)) %then
			%do;
				drop view &lib..&table.;
			%end;
	quit;

	FILENAME REFFILE DISK "&path./&table..csv";

	PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=&lib..&table.;
		GETNAMES=YES;
	RUN;

	PROC CONTENTS DATA=&lib..&table.;
	RUN;
%mend import_tables;

*load specific table to cas;
%macro load_tables(table=,lib=, sess=);
	proc casutil outcaslib=&lib. sessref="&sess." incaslib=&lib.;
    	save casdata="&table." compress replace;
    	promote casdata="&table.";
	quit;
%mend load_tables;

*import and load tables from a directory;
%macro import_tables_from_directory(path=, lib=, sess=);
	%local fref rc did name i;
	%let rc=%sysfunc(filename(fref, "&path."));
	%let did=%sysfunc(dopen(&fref.));

	%if &did. <=0 %then
		%do;
			%put ERROR: Unable to open directory;
			%return;
		%end;

	%do i=1 %to %sysfunc(dnum(&did.));
		%let name=%qsysfunc(dread(&did., &i.));
		%let fid=%sysfunc(mopen(&did., &name.));

		%if &fid. > 0 %then
			%do;
				%import_tables(path=&path., table=%sysfunc(substr(&name., 1, %length(&name.)-4)), lib=&lib.) 
				%load_tables(table=%sysfunc(substr(&name., 1, %length(&name.)-4)), lib=&lib., sess=&sess.)
			%end;
	%end;
%mend import_tables_from_directory;

*calling macros;
%import_tables_from_directory(path=/shared/home/aysu.kaymak@gazi.edu.tr/sasuser.viya/depression/data/condition, 
		lib=CASUSER, sess=impsess) 
%import_tables_from_directory(path=/shared/home/aysu.kaymak@gazi.edu.tr/sasuser.viya/depression/data/control, 
		lib=CASUSER, sess=impsess) 
%import_tables(path=/shared/home/aysu.kaymak@gazi.edu.tr/sasuser.viya/depression/data/, table=scores,
		lib=CASUSER) 
%load_tables(table=scores ,lib=CASUSER, sess=impsess)
