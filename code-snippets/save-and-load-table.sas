cas casauto;
caslib _all_ assign;
options compress=yes;

%macro save_table(inlib=, outlib=, sess=, indata=, outdata=);

    proc casutil incaslib=&inlib. sessref=&sess. outcaslib=&outlib.;
        save casdata="&indata." casout="&outdata..sashdat" compress replace;
    quit;
%mend;

%macro load_table(inlib=, outlib=, indata=, outdata=);

    proc casutil;
        load incaslib=&inlib. outcaslib=&outlib. casdata="&indata..sashdat"
            casout="&outdata." replace;
    quit;

    proc casutil;
        promote incaslib=&inlib. outcaslib=&outlib. casdata="&indata."
            casout="&outdata.";
    quit;
%mend;

%macro remove_table(lib=, table=);
    %if(%sysfunc(exist(&lib..&table.))) %then %do;

        proc delete data=&lib..&table.;
        quit;
    %end;
%mend;

%remove_table(lib=public, table=commsdata);
%save_table(inlib=ADML, outlib=PUBLIC, sess=casauto, indata=COMMSDATA,
    outdata=COMMSDATA);
%load_table(inlib=PUBLIC, outlib=PUBLIC, indata=COMMSDATA, outdata=COMMSDATA)
