#!/bin/bash

# Step 1: Fetch the HTML content of the page
url="http://10.0.17.6/Assignment.html"  # Replace with the actual URL
html_content=$(curl -s "$url")

# Step 2: Extract Temperature data (rows from the temperature table)
temp_data=$(echo "$html_content" | grep -oP '(?<=<tr>\s*<td>)[^<]+' | paste - -)

# Step 3: Extract Pressure data (rows from the pressure table)
press_data=$(echo "$html_content" | grep -oP '(?<=<tr>\s*<td>)[^<]+' | paste - -)

# Step 4: Merge the temperature and pressure data based on Date-Time
# First, process the temperature data into a suitable format
temp_data=$(echo "$temp_data" | awk 'NR % 2 == 1 {temperature=$1} NR % 2 == 0 {print temperature, $1}')

# Process the pressure data into a suitable format
press_data=$(echo "$press_data" | awk 'NR % 2 == 1 {pressure=$1} NR % 2 == 0 {print pressure, $1}')

# Step 5: Merge the data by matching Date-Time
# Assuming both tables have the same Date-Time order and number of rows
echo -e "Date-Time\tTemperature\tPressure"
paste <(echo "$temp_data") <(echo "$press_data") | awk '{print $2, "\t", $1, "\t", $3}'
