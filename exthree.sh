#!/bin/bash

HOLDER=()

#Color Setup
GREEN='\033[0;32m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NONE='\033[0m'

#-h --help
function SHOWUSAGE(){
    echo -e "\n"
    echo "USAGE ./exthree.ssh [options] [file]"
    echo -e "\n\n"
    echo "Options: "
    echo -e "\n"
    echo "-h | --help"
    echo -e "\n"
    echo "-q | --query <query keyword>"
    echo -e "\n"
    echo "-o | --output <output-file>"
    echo -e "\n"
    echo "-i | --interactive"
    echo -e "\n"
    echo "Extras/Optional:"
    echo -e "\n"
    echo "-c | --color" 
    echo "Colorize stdout console output"
    echo -e "\n"
    echo "-s | --stats"
    echo "Print to Stdout and to file"
    echo -e "\n"
}

#-q --query
function GETKEYWORD(){
    echo -e "\nWhats the keyword you would like to find?"
    read KEYWORD
    echo -e "\nWhats the files name?"
    read FILENAME
    echo -e "\n"
    if [[ -n $FILENAME ]]; then
        echo -e "${GREEN}Matching results:${NONE}"
        SEARCHKEYWORD $KEYWORD $FILENAME
    else
        echo "You didn't provide a file to be scrapped..."
    fi
    
    echo -e "\n"
}

#Supplies other functions with the search logic
function SEARCHKEYWORD(){
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $line == *"$1"* ]]; then
            echo -e "\n$line"
        fi
    done < "$2"
    #Used to get Stdout back to console when we call -o|--output
    exec 1> /dev/tty

}

#-o --output
function SEARCHOUTPUT(){
    echo -e "\nWhat is the keyword?"
    read KEYWORD
    echo -e "\nWhat is the filename?"
    read NAME
    echo -e "\nName of the file to output to"
    read OUTPUTFILE
    exec 1>$OUTPUTFILE
    SEARCHKEYWORD $KEYWORD $NAME
    echo -e "\n"
}

#-c --color
function SEARCHCOLOR(){
    echo -e "\nWhat is the keyword?"
    read KEYWORD
    echo -e "\nWhat is the filename?"
    read NAME
    echo -e "\n"
    echo -e "${GREEN}Matching results:${NONE} \n"
    egrep --color "$KEYWORD" "$NAME"
    echo -e "\n"
}

#-s --stats
function STATS(){
    echo -e "\nWhat is the keyword?"
    read KEYWORD
    echo -e "\nWhat is the filename?"
    read NAME
    echo -e "\nWhats the output file?"
    read OUTPUTFILE
    if [[ -n $OUTPUTFILE ]]; then
        #echo -e "\n${GREEN}Matching results:${NONE} \n"
        #SEARCHKEYWORD $KEYWORD $NAME | tee $OUTPUTFILE
        #Fetches line numbers where the keyword is present
        LINE_NUMBER=($(grep -n "$KEYWORD" "$NAME" | cut -f1 -d: | sort -u))
        echo -e "\n${BLUE}Stats${NONE}"
        echo -e "\n" | tee -a "$OUTPUTFILE"
        for i in ${LINE_NUMBER[@]}; do
            echo "$NAME - $i" | tee -a "$OUTPUTFILE"
        done
        LINES_KEYWORD=$(grep -r "$KEYWORD" "$NAME" | wc -l)
        LINES=$(wc -l < "$OUTPUTFILE")
        OCCURENCES=$(grep -o "$KEYWORD" "$OUTPUTFILE" | wc -l)
        echo -e "\n\"$KEYWORD\" appears $OCCURENCES times in $LINES lines.\n$LINES_KEYWORD lines contain the keyword.\n"
    else
        echo "You didn't provide a file to be scrapped..."
    fi
    echo -e "\n"
}

#Manages interactive mode
function INTERACTIVEMODE(){
    while true
    do
        echo -e "${WHITE}What would you like to do?${NONE}"
        echo "1- Help / See Usage"
        echo "2- Search for a keyword"
        echo "3- Search for a keyword (+ output to a file)"
        echo "4- Highlight the keyword"
        echo "5- Get Stats"
        echo "0- Quit"
        read choice
        case "$choice" in
            1)
                SHOWUSAGE
                continue
                ;;
            2)
                GETKEYWORD
                continue
                ;;
            3)
                SEARCHOUTPUT
                continue
                ;;
            4)
                SEARCHCOLOR
                continue
                ;;
            5)
                STATS
                continue
                ;;
            0)
                echo -e "\nGoodbye!\n"
                exit 0
                ;;
            *)
                echo -e "Not a valid option... \n"
                continue
                ;;
        esac
    done
}

#Manages the command execution
function EXECUTECOMMAND(){
    #If we are not providing a -q throws an error, except if the flag -h is present it is ok as we are seeking help
    if [[ ! $* == *-q* ]] && [[ ! $* == *--query* ]] && [[ ! *$* == *-h* ]] && [[ ! *$* == *--help* ]]; then
        echo -e "\n${RED}ERROR: You need to provide the ${PURPLE}-q | --query ${RED}flag in order to search a keyword${NONE}"
        echo -e "Flag usage: ${PURPLE}-q | --query <keyword>${NONE}\n"
    fi
    if [[ $* == *-h* ]] || [[ $* == *--help* ]]; then
        SHOWUSAGE
    fi
    if [[ $* == *-q* ]] || [[ $* == *--query* ]]; then
        if [[ $* == *-o* ]] || [[ $* == *--output* ]]; then
            exec 1>"$3"
            SEARCHKEYWORD $1 $2
            exec 1>/dev/tty
        fi
        if [[ $* == *-s* ]] || [[ $* == *--stats* ]]; then
            LINE_NUMBER=($(grep -n "$1" "$2" | cut -f1 -d: | sort -u))
            echo -e "\n${BLUE}Stats${NONE}"
            echo -e "\n" | tee -a "$3"
            for i in ${LINE_NUMBER[@]}; do
                echo "$2 - $i" | tee -a "$3"
            done
            LINES_KEYWORD=$(grep -r "$1" "$2" | wc -l)
            LINES=$(wc -l < "$2")
            OCCURENCES=$(grep -o "$1" "$3" | wc -l)
            echo -e "\n\"$KEYWORD\" appears $OCCURENCES times in $LINES lines.\n$LINES_KEYWORD lines contain the keyword.\n"
        fi
        if [[ $* == *-c* ]] || [[ $* == *--color* ]]; then
            echo -e "\n${GREEN}Matching results:${NONE}\n"
            egrep --color "$1" "$2"
            echo -e "\n"
        else
            echo -e "\n${GREEN}Matching results:${NONE}"
            SEARCHKEYWORD $1 $2
            echo -e "\n"
        fi


    fi
}

#Inserts every flag into an array so that the command call can work properly
function COMMANDCALL(){
    INPUT_FILE="${@: -1}"
    if [[ -f $INPUT_FILE ]]; then
        while [[ $# != 0 ]]
        do

            if [[ $# -eq 1 ]]; then
                #for i in ${HOLDER[@]}; do
                #    echo "$i"
                #done
                EXECUTECOMMAND $KEYWORD $INPUT_FILE $OUTPUT_FILE ${HOLDER[@]}
                exit 0
            else

                case "$1" in
                    -h | --help)
                        #echo "Got to -h | --help"
                        HOLDER+=("$1")
                        shift
                        ;;
                    -q | --query)
                        #echo "Got to -q | --query"
                        HOLDER+=("$1")
                        shift
                        KEYWORD="$1"
                        shift
                        ;;
                    -o | --output)
                        #echo "Got to -o | --output"
                        HOLDER+=("$1")
                        shift
                        if [[ -f $1 ]]; then
                            OUTPUT_FILE="$1"
                            shift
                        else
                            echo -e "\n${RED}ERROR: Output file not provided${NONE}"
                            echo -e "Flag usage: ${PURPLE}-o | --output <output file>${NONE}\n"
                            exit 0
                        fi
                        ;;
                    -s | --stats)
                        #echo "Got to -s | --stats"
                        HOLDER+=("$1")
                        shift
                        ;;
                    -c | --color)
                        #echo "Got to -c | --color"
                        HOLDER+=("$1")
                        shift
                        ;;
                    *)
                        echo -e "\n${RED}ERROR: Invalid flag ${PURPLE}$1${NONE} ${NONE}"
                        echo -e "Valid flags:\n-h | --help\n-q | --query\n-o | --output\n-c | --color\n-s | --stats\n-i | --interactive\n"
                        exit 0
                        ;;
                esac
            fi
        done
    elif [[ $* != *-h* ]] || [[ $* != *--help* ]]; then
        SHOWUSAGE
        shift
    else
        echo "You need to provide a valid input file..."
        exit 0
    fi
}

#If we have the -i flag then interactive mode takes over and the other flags get unattended
function HANDLECOMMAND(){
    #HOLDER=("$@")
    if [[ $* == *-i* ]] || [[ *$ == *--interactive* ]]; then
        INTERACTIVEMODE $@
    else
        COMMANDCALL $@
    fi
}

#Lets start our program
HANDLECOMMAND $@