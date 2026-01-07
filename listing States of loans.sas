data work.homeequity_update; 
    set start.homeequity; 
    city=propcase(city); 
run; 

title "Nomber of loans by State"; 
ods noproctitle; 
proc freq data=work.homeequity_update  order=freq;
   tables State / nocum;
run;
