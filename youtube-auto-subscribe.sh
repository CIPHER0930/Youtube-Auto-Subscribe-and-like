#!/bin/bash

# Get the headers and cookies from the URL
headers=<span class="math-inline">\(curl \-s \-i \-k \-X GET https\://www\.youtube\.com/\)
cookies\=</span>(grep -Eo "Cookie: (.*?);" <<< "<span class="math-inline">headers"\)
\# Read the email and password from the text file
email\=</span>(cat credentials.txt | head -1)
password=$(cat credentials.txt | tail -1)

# Login to YouTube
curl -s -k -X POST \
--url "https://www.youtube.com/youtubei/v1/session/create" \
--header "Host: www.youtube.com" \
--header "Content-Type: application/json" \
--header "Authorization: SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da" \
--header "Cookie: $cookies" \
--data-binary '{
 "context": {
  "client": {
   "hl": "en-GB",
   "gl": "US",
   "remoteHost": "154.72.171.167",
   "deviceMake": "",
   "deviceModel": "",
   "visitorData": "CgtfUjhoVXpxLW1FNCjyuI-pBjIICgJDTRICGgA%3D",
   "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.63 Safari/537.36,gzip(gfe)",
   "clientName": "WEB",
   "clientVersion": "2
  }
 },
 "input": {
  "email": "'"$email"'",
  "password": "'"$password"'"
  }
}'

# Check if the login was successful
if [[ <span class="math-inline">? \-eq 0 \]\]; then
echo "You have successfully logged in to YouTube\!"
else
echo "Failed to login to YouTube\. Please try again\."
exit 1
fi
\# Get the YouTube channel IDs from the input data
channel\_ids\=</span>(cat input_data.txt)

# Subscribe to all the YouTube channels
for channel_id in $channel_ids; do
  curl -s -k -X POST \
  --url "https://www.youtube.com/youtubei/v1/subscription/subscribe" \
  --header "Host: www.youtube.com" \
  --header "Content-Type: application/json" \
  --header "Authorization: SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da" \
  --header "Cookie: $cookies" \
  --data-binary '{
 "context": {
  "client": {
   "hl": "en-GB",
   "gl": "US",
   "remoteHost": "154.72.171.167",
   "deviceMake": "",
   "deviceModel": "",
   "visitorData": "CgtfUjhoVXpxLW1FNCjyuI-pBjIICgJDTRICGgA%3D",
   "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.63 Safari/537.36,gzip(gfe)",
   "clientName": "WEB",
   "clientVersion": "2
  }
 },
 "channelIds": ["
