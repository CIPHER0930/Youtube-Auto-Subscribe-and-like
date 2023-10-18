#!/bin/bash

# Set the -e option to cause the script to exit immediately if any command returns a non-zero exit status
set -e

# Define a trap handler function
trap 'echo "An error occurred in the script. Exiting."; exit 1' ERR

# Number of usernames to generate
num_usernames=10

# File to store the created usernames
output_file="created_usernames.txt"

# Generate usernames
for ((i=1; i<=num_usernames; i++)); do

  # Generate a random username
  username="user_$i"

  # Extract the headers and cookies from the URL automatically
  headers=$(grep -P '(HTTP\/[0-9]+\.[0-9]+\s+[0-9]+\s+.+)' google_username_availability.sh)
  cookies=$(grep -P 'Set-Cookie: ([^=]+)=([^;]+)' google_username_availability.sh)

  # Make the curl request with the extracted cookies and headers
  response=$(curl -s -k -X POST \
    -H "$headers" \
    -b "$cookies" \
    "https://accounts.google.com/_/signup/usernameavailability?hl=en-GB&TL=AJeL0C7r3yb35bvxAOoQT3mCSZVwyZU06buAZNJhlvpOu8To-stCqNMCxobYdB2K&_reqid=743849&rt=j")

  # Check if the username is available
  if [[ $response == *'"isAvailable":true'* ]]; then
    echo "Creating Gmail account with username: $username"

    # Create Gmail account with the extracted headers, cookies, and the username
    gmail_response=$(curl -s -k -X POST \
      -H "$headers" \
      -b "$cookies" \
      --data "username=$username" \
      "https://accounts.google.com/_/signup/v1/selfsignup/createaccount")

    # Store the created usernames in the output file
    if [[ $gmail_response == *'"accountState":1'* ]]; then
      echo "$username" >> "$output_file"
      echo "Username '$username' created successfully."
    else
      echo "Failed to create username: $username"
    fi
  else
    echo "Username '$username' is not available."
  fi
done

# Exit the script successfully
exit 0
