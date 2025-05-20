#!/bin/bash

# Get the directory where the script is located
script_dir=$(dirname "$(realpath "$0")")

# Path to the exclusion file
exclusion_file="$script_dir/exclusions.txt"

# Extract the date components from the ls -l output
timestamp=$(ls -l /etc/ssh/ssh_host_ecdsa_key | awk '{print $6, $7, $8}')

# Use the `date` command to format the extracted date to YYYY-MM-DD
begin_date=$(date -d "$timestamp" '+%Y-%m-%d')

# Output the formatted date
echo "Begin date: $begin_date"

# Get the user input for the number of months forward
read -p "Enter the number of months forward (default is 0, meaning up to today): " months_forward

# If no input is given, default to 0
months_forward=${months_forward:-0}

# Calculate the next month date based on user input
if [ "$months_forward" -eq 0 ]; then
	    next_month_date=$(date '+%Y-%m-%d')
    else
	        next_month_date=$(date -d "$begin_date +$months_forward month" '+%Y-%m-%d')
fi

# Output the next month date
echo "Next month date: $next_month_date"

# Check if exclusion file exists
if [ ! -f "$exclusion_file" ]; then
	    echo "Exclusion file not found: $exclusion_file"
	        exit 1
fi

# Prepare the exclusion patterns, ensuring they are on a single line
exclusions=$(awk '{printf "-path \"%s\" -prune -o ", $0}' "$exclusion_file")

# Output exclusions for debugging
#echo "Exclusion patterns: $exclusions"

# Combine with additional grep exclusions
additional_exclusions='/etc\|/var/lib\|/var/cache\|/sys\|/proc\|/boot\|/lib\|/usr/share\|/usr/lib\|/usr/src\|/usr/include\|/snap\|/run'

# Final find command with grep exclusions
eval find / $exclusions -newermt "$begin_date" ! -newermt "$next_month_date" -ls 2> /dev/null | grep -v "$additional_exclusions"

