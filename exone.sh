#!/bin/bash

#Color setup
GREEN='\033[0;32m'
RED='\033[0;31m'
NONE='\033[0m'

#Check if number or star on our ballot matches the winner combinations 
checkequal(){
    SEEKING=$1
    shift
    array=("$@")
    abc=1
    for element in "${array[@]}"; do
        if [[ $element == $SEEKING ]]; then
            abc=0
            break
        fi
    done
    return $abc
}

#Draws the winning number and stars and then organizes them (asc)
WINNER_NUMBERS=($(shuf -i 1-50 -n 5))
WINNER_STARS=($(shuf -i 1-12 -n 2))
SORTED_WNUMBER=($(echo ${WINNER_NUMBERS[*]}| tr " " "\n" | sort -n))
SORTER_WSTARS=($(echo ${WINNER_STARS[*]}| tr " " "\n" | sort -n))
echo -e "\n--------------------------------"

#Creates 3 ballots and organizes each (asc)
for i in 1 2 3; 
    do
        NUMBERS=($(shuf -i 1-50 -n 5))
        STARS=($(shuf -i 1-12 -n 2))
        SORTED_NUMBERS=($(echo ${NUMBERS[*]}| tr " " "\n" | sort -n))
        SORTED_STARS=($(echo ${STARS[*]}| tr " " "\n" | sort -n))

        echo -e "\nBallot#${i}"
        echo "Numbers - ${SORTED_NUMBERS[@]}"  
        echo "Stars - ${SORTED_STARS[@]}"

        #For a fun visual, draws the ballot on the terminal
        echo -e "--------------------------------"
        echo -e "Your Simulated Ballot\n"
        #Draws the numbers first
        T=0
        TOTAL=0
        NUMBERS=0
        STARS=0
        CONTROLO=0
        for a in {1..5};
            do
                for b in {1..10};
                do
                    T=$((T+1))
                    if echo ${SORTED_NUMBERS[@]} | grep -q -w "$T"; then
                        checkequal $T ${SORTED_WNUMBER[@]} && echo -e " ${GREEN}X${NONE} \c" || echo -e " ${RED}X${NONE} \c"
                        checkequal $T ${SORTED_WNUMBER[@]}  && TOTAL=$((TOTAL+5000)) NUMBERS=$((NUMBERS+1)) || CONTROLO=0
                    else
                        if [[ $T -lt 10 ]]; then
                            echo -e " $T \c"
                        else
                            echo -e "$T \c"
                        fi
                    fi
                done
                echo -e "\n\n"
            done
        
        #Now the stars
        G=0
        for c in {1..4};
            do
                for d in {1..3};
                do
                    G=$((G+1))
                    if echo ${SORTED_STARS[@]} | grep -q -w "$G"; then
                        checkequal $G ${SORTER_WSTARS[@]} && echo -e " ${GREEN}X${NONE} \c" || echo -e " ${RED}X${NONE} \c"
                        checkequal $G ${SORTER_WSTARS[@]} && TOTAL=$((TOTAL+1000)) STARS=$((STARS+1)) || CONTROLO=0
                    else
                        if [[ $G -lt 10 ]]; then
                            echo -e " $G \c"
                        else
                            echo -e "$G \c"
                        fi
                    fi
                done
                echo -e "\n"
            done

        #Calculates a user's earnings per ballot
        echo -e "--------------------------------"
        echo "Your earnings!"
        echo "You have got $NUMBERS numbers and $STARS stars correct!"
        echo "You have made a total of $TOTAL euros!"
        echo -e "--------------------------------"
    done

#Prints out the winning combination
echo -e "\n\n--------------------------------"
echo -e "Winner:\n"
echo "Numbers - ${SORTED_WNUMBER[@]}"
echo "Stars - ${SORTER_WSTARS[@]}"
echo -e "--------------------------------\n\n"
