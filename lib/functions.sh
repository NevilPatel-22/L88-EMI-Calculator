#!/bin/bash
# lib/functions.sh – EMI Calculator
# Write ALL functions here. main.sh loads this file with: source lib/functions.sh
DATA="$HOME/linux_project/emicalc/data/loans.csv"

LOG="logs/activity.log"

# TODO: log  -> write one line "date time | message" into $LOG
#        hint: date, echo, >>
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG"
}

# TODO: check_data -> if $DATA does not exist, print a message and return 1
#        hint: file test operators (-e, -f, -d)
check_data() {
    if [ ! -f "$DATA" ]; then 
	echo "Loan data file not found!"
	return 1
    fi
    return 0
}

# TODO: show_help -> print how to use ./main.sh, ./main.sh --help, --backup, --cron
show_help() {
    echo "EMI Calculator - Help"
    echo "Usage: ./main.sh"
    echo "1. Calculator EMI"
    echo "2. View loan data"
    echo "3. Backup data"
    echo "4. View activity log"
    echo "5. Exit" 
}

# TODO: view_data -> show the data file with line numbers (or list the folder)
#        hint: cat -n, more, ls -l
view_data() {
    if check_data; then
	echo "Loan Records:"
	column -t -s ',' "$DATA"
    fi
}

# TODO: do_backup -> create backups/data_<date_time>.tar.gz of the data/ folder
#        hint: tar -czf, date +%Y%m%d_%H%M%S, du -h
do_backup() {
    mkdir -p backups
    tar -czf "backups/loans_$(date +%Y%m%d_%H%M%S).tar.gz" data/
    echo "Backup created successfully!"
    log "Loan data backup created"
}

# TODO: view_log -> show the last 15 lines of $LOG
#        hint: tail
view_log() {
    if [ -f "$LOG" ]; then
	tail -n 15 "$LOG"
    else
	echo "No activity log found!"
    fi
}

# ------------------------------------------------------------
# FEATURE 1: Take principal, rate and months as command-line arguments or input
# Commands you can use: $1 $2 $3, bc -l, while loop, printf
# Hints (see Step 5 of your guide):
#   - Columns in your data file are separated by a comma: item, principal, rate, months, emi.
#   - Ask the user what to search for with read -p.
#   - Search the data file with grep (ignore upper/lower case).
#   - If nothing is found, show a friendly message (check the exit status $?).
#   - Show only the columns that matter (cut or awk).
# ------------------------------------------------------------
feature_1() {
    # Step 1: Take input
    if [ "$#" -ge 3 ]; then
        principal="$1"
        rate="$2"
        months="$3"
    else
        read -p "Enter principal amount: " principal
        read -p "Enter annual interest rate: " rate
        read -p "Enter loan duration in months: " months
    fi

    # Step 2: Validate principal
    if [[ ! "$principal" =~ ^[0-9]+([.][0-9]+)?$ ]] || [ "$principal" = "0" ]; then
        echo "Invalid principal amount!"
        return 1
    fi

    # Step 3: Validate interest rate
    if [[ ! "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Invalid interest rate!"
        return 1
    fi

    # Step 4: Validate months
    if ! [[ "$months" =~ ^[0-9]+$ ]] || [ "$months" -le 0 ]; then
        echo "Invalid loan duration!"
        return 1
    fi

    # Step 5: Display details
    echo "Loan Details:"
    echo "Principal: $principal"
    echo "Interest Rate: $rate%"
    echo "Duration: $months months"

    # Step 6: Save log
    log "Loan details entered"
}

# ------------------------------------------------------------
# FEATURE 2: Calculate EMI with bc -l
# Commands you can use: $1 $2 $3, bc -l, while loop, printf
# Hints (see Step 6 of your guide):
#   - Columns in your data file are separated by a comma: item, principal, rate, months, emi.
#   - Use awk with the right field separator to read the number column (principal is column 2).
#   - Skip the header line (it is line 1).
#   - Add the values (and count them if you need an average) and print the result neatly with printf.
#   - For decimals in bash use bc (scale=2).
# ------------------------------------------------------------
feature_2() {
    read -p "Enter principal amount: " principal
    read -p "Enter annual interest rate: " rate
    read -p "Enter loan duration in months: " months

    if [[ ! "$principal" =~ ^[0-9]+([.][0-9]+)?$ ]] || [ "$principal" = "0" ]; then
        echo "Invalid principal amount!"
        return 1
    fi

    if [[ ! "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Invalid interest rate!"
        return 1
    fi

    if ! [[ "$months" =~ ^[0-9]+$ ]] || [ "$months" -le 0 ]; then
        echo "Invalid loan duration!"
        return 1
    fi

    monthly_rate=$(echo "scale=10; $rate/1200" | bc -l)

    if [ "$rate" = "0" ]; then
        emi=$(echo "scale=2; $principal/$months" | bc -l)
    else
        emi=$(echo "scale=2; $principal*$monthly_rate*(1+$monthly_rate)^$months/((1+$monthly_rate)^$months-1)" | bc -l)
    fi

    echo "Monthly EMI: Rs. $emi"
    log "EMI calculated: Rs. $emi"
}

# ------------------------------------------------------------
# FEATURE 3: Print the month-by-month table (interest, principal, balance)
# Commands you can use: $1 $2 $3, bc -l, while loop, printf
# Hints (see Step 7 of your guide):
#   - Columns in your data file are separated by a comma: item, principal, rate, months, emi.
#   - Collect the output of your commands in one block.
#   - Write it into the reports/ folder; put today's date in the file name (date command).
#   - Use > to create the file and >> to add more lines.
#   - Tell the user the file name that was saved.
# ------------------------------------------------------------
feature_3() {
    read -p "Enter principal amount: " principal
    read -p "Enter annual interest rate: " rate
    read -p "Enter loan duration in months: " months

    # Validate principal
    if [[ ! "$principal" =~ ^[0-9]+([.][0-9]+)?$ ]] || [ "$principal" = "0" ]; then
        echo "Invalid principal amount!"
        return 1
    fi

    # Validate interest rate
    if [[ ! "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Invalid interest rate!"
        return 1
    fi

    # Validate months
    if ! [[ "$months" =~ ^[0-9]+$ ]] || [ "$months" -le 0 ]; then
        echo "Invalid loan duration!"
        return 1
    fi

    # Calculate EMI
    monthly_rate=$(echo "scale=10; $rate/1200" | bc -l)

    if [ "$rate" = "0" ]; then
        emi=$(echo "scale=2; $principal/$months" | bc -l)
    else
        emi=$(echo "scale=10; $principal*$monthly_rate*(1+$monthly_rate)^$months/((1+$monthly_rate)^$months-1)" | bc -l)
    fi

    # Calculate monthly schedule
    balance=$principal

    echo "Month    Interest    Principal    Balance"
    echo "------------------------------------------"

    for ((i=1; i<=months; i++))
    do
        interest=$(echo "scale=2; $balance*$monthly_rate" | bc -l)
        principal_paid=$(echo "scale=2; $emi-$interest" | bc -l)
        balance=$(echo "scale=2; $balance-$principal_paid" | bc -l)

        if [ "$i" -eq "$months" ]; then
            balance="0.00"
        fi

        printf "%-8s %-11s %-12s %s\n" "$i" "$interest" "$principal_paid" "$balance"
    done

    log "Monthly EMI schedule displayed"
}

# ------------------------------------------------------------
# FEATURE 4: Compare two loan options
# Commands you can use: $1 $2 $3, bc -l, while loop, printf
# Hints (see Step 8 of your guide):
#   - Columns in your data file are separated by a comma: item, principal, rate, months, emi.
#   - Ask the user what to search for with read -p.
#   - Search the data file with grep (ignore upper/lower case).
#   - If nothing is found, show a friendly message (check the exit status $?).
#   - Show only the columns that matter (cut or awk).
# ------------------------------------------------------------
feature_4() {
    echo "Enter Loan Option 1 Details:"
    read -p "Enter principal amount: " p1
    read -p "Enter annual interest rate: " r1
    read -p "Enter duration in months: " m1

    echo ""
    echo "Enter Loan Option 2 Details:"
    read -p "Enter principal amount: " p2
    read -p "Enter annual interest rate: " r2
    read -p "Enter duration in months: " m2

    # Validate inputs
    for value in "$p1" "$r1" "$p2" "$r2"; do
        if ! [[ "$value" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            echo "Invalid loan amount or interest rate!"
            return 1
        fi
    done

    if [ "$p1" = "0" ] || [ "$p2" = "0" ] ||
       ! [[ "$m1" =~ ^[0-9]+$ ]] || [ "$m1" -le 0 ] ||
       ! [[ "$m2" =~ ^[0-9]+$ ]] || [ "$m2" -le 0 ]; then
        echo "Invalid principal or loan duration!"
        return 1
    fi

    # Calculate EMI for Option 1
    mr1=$(echo "scale=10; $r1/1200" | bc -l)

    if [ "$r1" = "0" ]; then
        emi1=$(echo "scale=2; $p1/$m1" | bc -l)
    else
        emi1=$(echo "scale=2; $p1*$mr1*(1+$mr1)^$m1/((1+$mr1)^$m1-1)" | bc -l)
    fi

    # Calculate EMI for Option 2
    mr2=$(echo "scale=10; $r2/1200" | bc -l)

    if [ "$r2" = "0" ]; then
        emi2=$(echo "scale=2; $p2/$m2" | bc -l)
    else
        emi2=$(echo "scale=2; $p2*$mr2*(1+$mr2)^$m2/((1+$mr2)^$m2-1)" | bc -l)
    fi

    # Display comparison
    echo ""
    echo "Loan Comparison"
    echo "Option 1 EMI: Rs. $emi1"
    echo "Option 2 EMI: Rs. $emi2"

    if (( $(echo "$emi1 < $emi2" | bc -l) )); then
        echo "Option 1 has lower monthly EMI."
    elif (( $(echo "$emi2 < $emi1" | bc -l) )); then
        echo "Option 2 has lower monthly EMI."
    else
        echo "Both options have equal monthly EMI."
    fi

    log "Two loan options compared"
}

# ------------------------------------------------------------
# FEATURE 5: Save the result to loans.csv
# Commands you can use: $1 $2 $3, bc -l, while loop, printf
# Hints (see Step 9 of your guide):
#   - Columns in your data file are separated by a comma: item, principal, rate, months, emi.
#   - Collect the output of your commands in one block.
#   - Write it into the reports/ folder; put today's date in the file name (date command).
#   - Use > to create the file and >> to add more lines.
#   - Tell the user the file name that was saved.
# ------------------------------------------------------------
feature_5() {
    read -p "Enter loan name: " item
    read -p "Enter principal amount: " principal
    read -p "Enter annual interest rate: " rate
    read -p "Enter loan duration in months: " months

    # Validate inputs
    if [ -z "$item" ] ||
       ! [[ "$principal" =~ ^[0-9]+([.][0-9]+)?$ ]] ||
       [ "$principal" = "0" ] ||
       ! [[ "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]] ||
       ! [[ "$months" =~ ^[0-9]+$ ]] ||
       [ "$months" -le 0 ]; then
        echo "Invalid loan details!"
        return 1
    fi

    # Calculate EMI
    monthly_rate=$(echo "scale=10; $rate/1200" | bc -l)

    if [ "$rate" = "0" ]; then
        emi=$(echo "scale=2; $principal/$months" | bc -l)
    else
        emi=$(echo "scale=2; $principal*$monthly_rate*(1+$monthly_rate)^$months/((1+$monthly_rate)^$months-1)" | bc -l)
    fi

    # Save loan details to CSV
    if [ ! -f "$DATA" ]; then
        echo "item,principal,rate,months,emi" > "$DATA"
    fi

    echo "$item,$principal,$rate,$months,$emi" >> "$DATA"

    echo "Loan result saved successfully!"
    echo "Monthly EMI: Rs. $emi"

    log "Loan result saved to CSV"
}

# ------------------------------------------------------------
# CRON TASK: Every 1st of the month at 9 AM, write an 'EMI due' reminder to reminders.txt
# This runs when crontab calls:  ./main.sh --cron
# Write the output into reports/ or a file, and log it.
# ------------------------------------------------------------
cron_task() {
    echo "EMI due" >> reminder.txt
    echo "EMI reminder added successfully!"
    log "EMI due reminder added"
}
