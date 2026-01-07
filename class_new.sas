data class_new; 
    set sashelp.class; 
    ratio=height/weight; 
    label name="Student Name"
        sex="Gender"; 
run; 
proc print data=class_new; 
run; 