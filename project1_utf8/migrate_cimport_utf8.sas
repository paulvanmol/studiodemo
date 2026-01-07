/*Initialize project*/
%let path=/home/student/demo;
%let project=project1; 
%let encoding=utf8; 

/*Initialize the Project Libname*/
libname project1 "&path./&project._&encoding.";


/*
proc cport lib=project1 file="&path./&project._&encoding./&project..xpt";
    run; */

/*Check Encoding and locale options*/
proc options option=encoding;
run;
proc options option=locale;
run;

proc cimport lib=project1 
file="&path./&project._&encoding./&project..xpt" 
extendvar=1.5 extendformat=yes;
run; 

proc contents data=project1.diabetes; 
run;
proc contents data=project1.customer; 
run;