options comamid=tcp;
%let myserver=server.demo.sas.com;
signon myserver.__1234 user=student password='Metadata0'; 

libname svrlib "/home/student/demo/project1._latin1" server=myserver.__1234;
libname source cvp 'source-library-pathname'; 
libname target 'target-library-pathname';

proc migrate in=source slibref=svrlib out=target <options>;
run;
signoff myserver.__1234;