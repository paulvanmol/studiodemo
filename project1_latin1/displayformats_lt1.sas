/*Default locale en_US*/
proc options option=locale;
run; 
options locale=en_US; 
proc datasets lib=work kill; 
quit; 
proc format lib=project1.formats;
    value age low - 5='baby' 6 - 12='child' 13 - 15='teen' 16 - 30='youth' 31 -
        50='midlife' 51 - high='older';
run;

options locale=fr_FR;

proc format lib=project1.formats locale;
    value age low - 5='bébé' 6 - 12='enfant' 13 - 15='adolescent' 16 - 30=
        'jeune' 31 - 50='âge mur' 51 - high='senior';
run;

options fmtsearch=(project1/locale);

/* Set the locale back to English(US) */
options locale=en_US;

data datatst;
    input age sex $;
    attrib age format=age.;
    attrib sex format=$gender.;
    cards;
5 M 
6 F 
12 M 
13 F 
15 M 
16 F 
30 M 
35 F 
51 M 
100 F
;
run;
/* Use the English format catalog*/
title "Locale is English, Use the Original Format Catalog";

proc print data=datatst;
run;

/* Use the Romanian format catalog*/
options locale=fr_FR;
title 'Locale is fr_FR, Use the French Format Catalog';

proc print data=datatst;
run;
