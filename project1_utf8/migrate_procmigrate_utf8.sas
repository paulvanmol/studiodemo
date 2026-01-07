/*Initialize project*/
%let path=/home/student/demo;
%let project=project2; 
%let encoding=utf8; 
options dlcreatedir; 
/*Initialize the Project Libname*/
libname source cvp "&path./project1_latin1"; 
libname project1 "&path./&project._&encoding.";




/*Check Encoding and locale options*/
proc options option=encoding;
run;
proc options option=locale;
run;

proc migrate in=source out=project1 ;
run; 

proc contents data=project1.diabetes; 
run;
proc contents data=project1.customer; 
run;
proc catalog c=project1.sasmacr; contents;
run; 

/*characters in format were not converted correctly*/
proc format lib=project1.formats_fr_fr fmtlib; 
run; 