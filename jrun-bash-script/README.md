# jrun-bash-script
Bash script that optimizes the running java projects or .java files. 
`It automatically makes the file system:
     -> src:
        *This is where Java source files should go
        *Write your classes, interfaces and logic here.
     -> bin:
        *This is where your compiled .class files go after you build your project.
        *It mirrors the src structure but contains .class files, not .java.
     -> lib:
        *This folder contains external libraries (usually .jar files) your project needs.
        *For example, if you’re using something like mysql-connector.jar or log4j, it goes here.

`How to set up: 
   Copy this to your .bashrc file: 
    alias jrun='~/dotfiles/jrun-bash-script/runjava.sh'

   run in the terminal this command: source ~/.bashrc 

   and you are ready to use the jrun command


#crun-bash-script
just run that shit 

