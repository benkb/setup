Notes

File:

    *.dash:  Modulinos
    lib*.sh: Sibraries
    *.sh:    Scripts

Modules in Shell

- Modulinos and simple libraries can be sourced
- try to avoid global variables
- if they are needed, name them after 'MODULENAME__VARIABLENAME'
- functions are named similar to 'modulename__functionname()'


    

Modulinos:
    - A script that also can be loaded like a module
    - Rule is trying to start each new script as modulino
    - A modulino in shell has the ending on .dash

Libraries

    - libraries have no main function
    - file ending in on '*lib.sh'



