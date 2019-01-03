#Variables setup
YOURWINS=0
CPUWINS=0
ROUNDS=0
DRAWS=0

#Something new
New="New String"

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
        read first_input

        #Transforms input into lowercase to avoid any possible conflict
        user_input=${first_input,,}

        #We'll start all possible values in an array, shuffle it and then shuffle through values {0-1-2} and store it in a variable.
        #This value will be the index of the element the CPU will chose in that particular round
        holder=('rock' 'paper' 'scissors')
        holder=($(shuf -e "${holder[@]}"))
        var=`shuf -i 0-2 -n 1`

        #Now let's see who wins
        if [[ $user_input == "rock" ]] || [[ $user_input == "r" ]] || [[ $user_input == "paper" ]] || [[ $user_input == "p" ]] || [[ $user_input == "scissors" ]] || [[ $user_input == "s" ]] ; then
            if [[ $user_input == "rock" ]] || [[ $user_input == "r" ]]; then
                CHOICE="Rock"
            elif [[ $user_input == "paper" ]] || [[ $user_input == "p" ]]; then
                CHOICE="Paper"
            else
                CHOICE="Scissors"
            fi
            echo -e "\nYou chose: $CHOICE"
            echo -e "Opponent chose: ${holder[var]^} \n"
        fi
        if [[ -n $user_input ]]; then
            if [ $user_input == "rock" ] || [[ $user_input == "r" ]]; then
                if [ ${holder[var]} == "rock" ]; then
                    echo -e "${BLUE}It is a draw${NONE}\n"
                    ROUNDS=$((ROUNDS+1))
                elif [ ${holder[var]} == "paper" ]; then
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

            elif [ $user_input == "paper" ] || [[ $user_input == "p" ]]; then
                if [ ${holder[var]} == "rock" ]; then
                    echo -e "${GREEN}You won\n${NONE}"
                    YOURWINS=$((YOURWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ YOURWINS -eq 3 ]]; then
                        STATS "won"
                        break
                    fi
                elif [ ${holder[var]} == "paper" ]; then
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

            elif [ $user_input == "scissors" ] || [[ $user_input == "s" ]]; then
                if [ ${holder[var]} == "rock" ]; then
                    echo -e "${RED}You lost${NONE}\n"
                    CPUWINS=$((CPUWINS+1))
                    ROUNDS=$((ROUNDS+1))
                    if [[ CPUWINS -eq 3 ]]; then
                        STATS "lost"
                        break
                    fi
                elif [ ${holder[var]} == "paper" ]; then
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



