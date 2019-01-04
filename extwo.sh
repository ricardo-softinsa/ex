#Variables setup
YOURWINS=0
CPUWINS=0
ROUNDS=0
DRAWS=0

#Color setup
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NONE='\033[0m'

#Prints out some stats game related
function STATS(){
    DRAWS=$((ROUNDS-(YOURWINS+CPUWINS)))
    echo -e "\n\n----------------------"
    echo -e "Stats\n"
    echo "Total of Rounds: $ROUNDS"
    echo "You won $YOURWINS rounds"
    echo "The CPU won $CPUWINS rounds"
    echo "You have drawn $DRAWS times"
    echo -e "\nYou have $1 the game."
    echo "----------------------"
    RETRY
}

#Allows the user to play again or to exit, if that's his will
function RETRY(){
    echo -e "\nWant to play again? (Y/N)"
    read OPTION
    OP=${OPTION,,}
    case "$OP" in
        y | yes)
            YOURWINS=0
            CPUWINS=0
            ROUNDS=0
            echo -e "\n"
            continue
            ;;
        n | no)
            echo -e "\nGoodbye!\n"
            break
            ;;
        *)
            echo "You have to choose Yes or No..."
            RETRY 
            ;;
    esac
}   

#Core of the game
while true;
    do
        echo "--------------------------------------"
        echo "Rock, Paper, Scissors?"
        read FIRST_INPUT

        #Transforms input into lowercase to avoid any possible conflict
        USER_INPUT=${FIRST_INPUT,,}

        #We'll start all possible values in an array, shuffle it and then shuffle through values {0-1-2} and store it in a variable.
        #This value will be the index of the element the CPU will chose in that particular round
        HOLDER=('rock' 'paper' 'scissors')
        HOLDER=($(shuf -e "${HOLDER[@]}"))
        var=`shuf -i 0-2 -n 1`

        #Now let's see who wins
        if [[ $USER_INPUT == "rock" ]] || [[ $USER_INPUT == "r" ]] || [[ $USER_INPUT == "paper" ]] || [[ $USER_INPUT == "p" ]] || [[ $USER_INPUT == "scissors" ]] || [[ $USER_INPUT == "s" ]] ; then
            if [[ $USER_INPUT == "rock" ]] || [[ $USER_INPUT == "r" ]]; then
                CHOICE="Rock"
            elif [[ $USER_INPUT == "paper" ]] || [[ $USER_INPUT == "p" ]]; then
                CHOICE="Paper"
            else
                CHOICE="Scissors"
            fi
            echo -e "\nYou chose: $CHOICE"
            echo -e "Opponent chose: ${HOLDER[var]^} \n"
        fi
        if [[ -n $USER_INPUT ]]; then
            if [ $USER_INPUT == "rock" ] || [[ $USER_INPUT == "r" ]]; then
                if [ ${HOLDER[var]} == "rock" ]; then
                    echo -e "${BLUE}It is a draw${NONE}\n"
                    ROUNDS=$((ROUNDS+1))
                elif [ ${HOLDER[var]} == "paper" ]; then
                    echo -e "${RED}You lost${NONE}\n"
                    CPUWINS=$((CPUWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ CPUWINS -eq 3 ]]; then
                        STATS "lost"
                        break
                    fi
                else
                    echo -e "${GREEN}You've won${NONE}\n"
                    YOURWINS=$((YOURWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ YOURWINS -eq 3 ]]; then
                        STATS "won"
                        break
                    fi
                fi

            elif [ $USER_INPUT == "paper" ] || [[ $USER_INPUT == "p" ]]; then
                if [ ${HOLDER[var]} == "rock" ]; then
                    echo -e "${GREEN}You won\n${NONE}"
                    YOURWINS=$((YOURWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ YOURWINS -eq 3 ]]; then
                        STATS "won"
                        break
                    fi
                elif [ ${HOLDER[var]} == "paper" ]; then
                    echo -e "${BLUE}It is a draw${NONE}\n"
                    ROUNDS=$((ROUNDS+1))
                else
                    echo -e "${RED}You lost\n${NONE}"
                    CPUWINS=$((CPUWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ CPUWINS -eq 3 ]]; then
                        STATS "lost"
                        break
                    fi
                fi

            elif [ $USER_INPUT == "scissors" ] || [[ $USER_INPUT == "s" ]]; then
                if [ ${HOLDER[var]} == "rock" ]; then
                    echo -e "${RED}You lost${NONE}\n"
                    CPUWINS=$((CPUWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ CPUWINS -eq 3 ]]; then
                        STATS "lost"
                        break
                    fi
                elif [ ${HOLDER[var]} == "paper" ]; then
                    echo -e "${GREEN}You won${NONE}\n"
                    YOURWINS=$((YOURWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ YOURWINS -eq 3 ]]; then
                        STATS "won"
                        break
                    fi
                else
                    echo -e "${BLUE}It is a draw${NONE}\n"
                    ROUNDS=$((ROUNDS+1))
                fi

            else
                echo "Invalid value"
                continue
            fi


            echo "--------------------------------------"


        else
            echo "You have to enter a value (rock, paper, scissors)"
            #continue
        fi
    done



