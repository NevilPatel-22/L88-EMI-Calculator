# L88 – EMI Calculator

**Student:** NEVIL JESANI | **Roll:** B25 | **Division:** H | **Enrollment:** 24004501210226
  ## Project Guide
This project was completed under the guidance of
**Dr. Anjum Y. Mansuri**, Assistant Professor, Computer Applications,
LJ Institute of Computer Applications, LJ University, Ahmedabad.
GitHub: [@anjum-mansuri](https://github.com/anjum-mansuri)

 OS Linux Lab 260120510 | Project ID: L88 EMI CALCULATOR
## Problem
Build an EMI calculator that prints a month-by-month repayment table.

## Who will use it
1. Students who want to understand EMI calculations.
2. People planning to take a loan.
3. Individuals who want to check monthly EMI and interest.
4. Users who want to compare two loan options.
5. People who want to maintain loan records.

## Folder structure
Folder Structure

emicalc/
│
├── main.sh
├── README.md
│
├── lib/
│   └── functions.sh
│
├── data/
│   └── loans.csv
│
├── reports/
│
├── backups/
│
└── logs/

## Features
1. Accepts loan principal, annual interest rate and loan duration.
2. Calculates monthly EMI using bc -l.
3. Displays a month-by-month repayment table.
4. Compares two different loan options.
5. Saves loan details in loans.csv.
6. Displays saved loan records.
7. Creates data backups in .tar.gz format.
8. Displays the last 15 activity log entries.
9. Provides a monthly EMI reminder using cron.
10. Supports command-line options like --help, --backup and --cron.

## How to run
1. Open Ubuntu terminal.
2. Go to the project directory:

   cd ~/linux_project/emicalc

3. Give execute permission:

   chmod +x main.sh

4. Run the project:

   ./main.sh

5. Follow the menu options and enter the required loan details.

./main.sh --help
./main.sh --backup
./main.sh --cron

## My crontab line and what it means
Crontab Line:

0 9 1 * * /bin/bash /home/nevil_ubantu/linux_project/emicalc/main.sh --cron

Meaning:

0       - Minute (0)
9       - Hour (9 AM)
1       - Day of the month (1st day)
*       - Every month
*       - Every day of the week

Command:

Runs the EMI reminder script using Bash.

It automatically runs on the 1st day of every month at 9:00 AM and adds an EMI due reminder.

## Commands I used and why

1. pwd
   - Shows the current working directory.

2. mkdir
   - Creates folders for the project.

3. cd
   - Moves into the project directory.

4. nano
   - Creates and edits files.

5. ls
   - Lists files and folders.

6. cat
   - Displays file contents.

7. chmod +x main.sh
   - Gives execute permission to the main script.

8. ./main.sh
   - Runs the EMI Calculator project.

9. bash -n main.sh
   - Checks the script for syntax errors.

10. tar -czf
    - Creates a compressed backup archive.

11. crontab -e
    - Opens the cron schedule for editing.

12. tail -n 15
    - Displays the last 15 lines of the activity log.

13. grep
    - Searches for specific text in a file.

14. bc -l
    - Performs mathematical calculations for EMI.

## What I learned
I learned how to create and run Bash scripts in Ubuntu.
I learned to calculate EMI using bc -l and display monthly repayment tables.
I learned file handling, data backup, and activity logging.
I also learned how to schedule automatic tasks using Cron.
