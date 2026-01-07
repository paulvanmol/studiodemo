/*Initialize project*/
%let path=/home/student/demo;
%let project=project1; 
%let encoding=latin1; 

/*Check Encoding and locale options*/
proc options option=encoding;
run;
proc options option=locale;
run;


/*Initialize the Project Libname*/
libname project1 "&path./&project._&encoding.";

data project1.diabetes;
    infile '/home/student/quick-start/diabetes.csv' dsd dlm=',' firstobs=2;
    input Gender:$1 Age:3. Urea:3. Cr:3. HbA1c:3. Chol:3. TG:3. HDL:3. LDL:3.
        VLDL:3. BMI:2. Class:$1.;
run;

proc contents data=project1.diabetes;
run;

options locale=en_US;

proc format lib=project1 fmtlib;
    value $gender 'F'='Female' 'M'='Male';
    value age low - 5='baby' 6 - 12='child' 13 - 15='teen' 16 - 30='youth' 31 -
        50='midlife' 51 - high='older';
run;
options fmtsearch=(project1/locale);

proc print data=project1.diabetes (obs=10);
    format gender $gender. age age.;
run;

options locale=fr_FR;

proc format lib=project1 fmtlib locale;
    value $gender 'F'='Femme' 'M'='Homme';
    value age low - 5='bébé' 6 - 12='enfant' 13 - 15='adolescent' 16 - 30=
        'jeune' 31 - 50='âge Mur' 51 - high='senior';
run;
run;
options fmtsearch=(project1/locale);

proc print data=project1.diabetes (obs=10);
    format gender $gender. age age.;
run;

proc cport lib=project1 file="&path./&project._&encoding./&project..xpt";
    run; 