/*Initialize project*/
%let path=/home/student/demo;
%let project=project1; 
%let encoding=latin1; 

/*Initialize the Project Libname*/
libname project1 "&path./&project._&encoding.";
proc cport lib=project1 file="&path./&project._&encoding./&project..xpt";
run;