#!/bin/bash
# main.sh – L88 EMI Calculator
# YOUR TASK: build the menu program in this file (Step 3 of your guide).
cd "$(dirname "$0")" || exit 1
source lib/functions.sh

# TODO 1: Command-line arguments
case "$1" in
    --help)
        show_help
        exit 0
        ;;
    --backup)
        do_backup
        exit 0
        ;;
    --cron)
        cron_task
        exit 0
        ;;
esac

# Feature 1: Command-line arguments
if [ "$#" -ge 3 ]; then
    feature_1 "$1" "$2" "$3"
    exit 0
fi

# TODO 2: Menu
while true
do
    echo ""
    echo "================================"
    echo "       L88 EMI CALCULATOR"
    echo "================================"
    echo "1) Take principal, rate and months"
    echo "2) Calculate EMI"
    echo "3) Print month-by-month table"
    echo "4) Compare two loan options"
    echo "5) Save result to loans.csv"
    echo "6) View data"
    echo "7) Backup data"
    echo "8) View activity log"
    echo "0) Exit"
    echo "================================"

    read -p "Enter your choice: " choice

    case "$choice" in
        1) feature_1 ;;
        2) feature_2 ;;
        3) feature_3 ;;
        4) feature_4 ;;
        5) feature_5 ;;
        6) view_data ;;
        7) do_backup ;;
        8) view_log ;;
        0)
            echo "Thank you for using EMI Calculator!"
            break
            ;;
        *)
            echo "Invalid choice! Please try again."
            ;;
    esac
done

# TODO 2: menu (use a while loop + read + case...esac)
#   Show a title, then these options, read the choice and call the function:
#     1) Take principal, rate and months as command-line arguments or input
#     2) Calculate EMI with bc -l
#     3) Print the month-by-month table (interest, principal, balance)
#     4) Compare two loan options
#     5) Save the result to loans.csv
#     6) View data            -> view_data
#     7) Backup data          -> do_backup
#     8) View activity log    -> view_log
#     0) Exit                 -> say bye and stop the loop (break)
#   Any other choice -> print "Invalid choice"


