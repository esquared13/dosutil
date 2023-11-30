#!/bin/bash

# erin enzinger
# purdue polytechnic institute columbus
# purpose: this script allows for use of familiar cmd commands in bash
# created by: erin enzinger
# created on: 11/2/2023
# modified by: erin enzinger
# modified on: 11/15/2023
# last revision reason/purpose: added bash command explanations

# VARIABLES
# - doscommands: an array to store the dos commands
# - userinput: stores user input
# - command: stores the command part of a user's input
# - arguments: stores the arguments a user enters after a command
# - source: used in different case statements to store the user-specified source file from user-specified arguments
# - destination: used to store user-specified file destinations

doscommands=("author" "type" "copy" "ren" "move" "del" "help" "exit")
readonly doscommands

sourceanddestination ()
{
    source="$1" # separates source from destination
    destination="$2" # separates destination from source
}

filechecker ()
{
    if [ -f "$source" ]; then 
        echo
        echo "The file '$source' exists."
        echo
    else
        if [ -d "$source" ]; then
            echo
            echo "The directory '$source' exists."
            echo
        else
            echo
            echo "The file or directory does not exist or was not specified."
            echo "Please enter a file or directory when using this command, separated by a space."
            echo
        fi
    fi
}

destinationalreadyexists ()
{
    if [ -f "$destinatinon" ]; then
        echo
        echo "Naming a file '$destination' would overwrite an existing file with the same name.  File was not created."
        echo
        return 1
    else
        return 0
    fi
}

author ()
{
    echo
    echo "dosutil was created by erin"
    echo
}

typefunction ()
{
    if [ -z "$arguments" ]; then
        echo
        echo "No file was specified."
        echo
    else
        source="$arguments"
        filechecker
        if [ -e "$arguments" ]; then
            cat "$arguments"
            echo
            echo "Bash command used: cat $arguments"
            echo
        else
            echo
            echo "File '$arguments' could not be viewed because it was not found."
            echo
        fi
    fi
}

copy ()
{
    if [ -z "$arguments" ]; then
        echo
        echo "No source and destination were specified.  Copy was unsuccessful."
        echo
    else
        sourceanddestination $arguments
        filechecker
        destinationalreadyexists
        if [ -e "$source" ]; then
            cp "$source" "$destination"
            echo
            echo "The file '$source' was copied to '$destination'."
            echo "Bash command used: cp $source $destination"
            echo
        else
            echo
            echo "Copying the file '$source' was unsuccessful because it was not found."
            echo        
        fi
    fi
}

ren ()
{
    if [ -z "$arguments" ]; then
        echo
        echo "No source and destination were specified.  Rename was unsuccessful."  
        echo
    else
        sourceanddestination $arguments
        filechecker
        destinationalreadyexists
        if [ -e "$source" ]; then
            mv "$source" "$destination"
            echo
            echo "File '$source' renamed to '$destination'."
            echo "Bash command used: mv $source $destination"
            echo
        else
            echo
            echo "Source file could not be renamed because the source file '$source' was not found."
            echo
        fi
    fi
}

move ()
{
    if [ -z "$arguments" ]; then
        echo
        echo "No source and destination were specified.  The move was unsuccessful."  
        echo
    else
        sourceanddestination $arguments
        filechecker
        destinationalreadyexists
        if [ -e "$source" ]; then
            mv "$source" "$destination"
            echo
            echo "File '$source' moved to '$destination'."
            echo "Bash command used: mv $source $destination"
            echo
        else
            echo
            echo "Source file could not be moved because the source file '$source' was not found."
            echo
        fi
    fi
}

del () 
{
    if [ -z "$arguments" ]; then
        echo
        echo "No file was specified."
        echo
    else
        source=$arguments
        filechecker
        if [ -e "$arguments" ]; then
            rm -r -f "$arguments"
            echo
            echo "The file '$arguments' deleted successfully."
            echo "Bash command used: rm -r -f $arguments"
            echo
        else
            echo
            echo "File '$arguments' could not be deleted because it was not found."
            echo
        fi
    fi
}

help ()
{
    echo
    echo "HELP DOCUMENTATION :)"
    echo "- author: reveals the author of this script and is not followed with any arguments."
    echo "- type: if the user enters type followed by a filename or path, the contents of the file will be typed by the computer for them."
    echo "- copy: if the user enters copy followed by a filename or path and a destination separated by a space, the computer will copy the first file to the destination."
    echo "- ren: if the user enters ren followed by two filenames or paths separated by a space, the computer will rename the first file to have the second name.  "
    echo "- del: if the user enters del followed by a filename or path, the computer will delete the file corresponding with the filename they specified.  with great power comes great responsibility."
    echo "- exit: exits the script.  no arguments needed."
    echo
}

exitfunction ()
{
    echo
    echo "Bye!"
    exit 0
}

errorfunction ()
{
    echo
    echo -n "$command is not recognized by this script."
    echo
}

while true; do
    echo
    read -rp "Please enter a DOS command and any arguments: " userinput
    echo
    command=$(echo "$userinput" | awk '{print $1}') # separates the command from the rest of the user input
    arguments=$(echo "$userinput" | cut -d" " -f2-) # separates the arguments from the rest of the user input
    case $command in
        ${doscommands[0]}) # author
            author
        ;;
        ${doscommands[1]}) # type
            typefunction
        ;;
        ${doscommands[2]}) # copy
            copy
            if [ $? -eq 1 ]; then # returns to the top of the loop if destination file already exists
                break
            fi
        ;;
        ${doscommands[3]}) # ren
            ren
            if [ $? -eq 1 ]; then # returns to the top of the loop if destination file already exists
                break
            fi
        ;;
        ${doscommands[4]}) # move (this code is basically the same thing as ren)
            move
            if [ $? -eq 1 ]; then # returns to the top of the loop if destination file already exists
                break
            fi
        ;;
        ${doscommands[5]}) # del
            del
        ;;
        ${doscommands[6]}) # help
            help
        ;;
        ${doscommands[7]}) # exit (this one isn't really a dos command i guess)
            exitfunction
        ;;  
        *) # default case
            errorfunction
        ;;
    esac
done