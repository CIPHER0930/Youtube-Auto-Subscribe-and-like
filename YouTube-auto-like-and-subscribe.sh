#!/bin/bash

# Get the headers and cookies from the URL
headers=$(curl -s -i -k -X GET https://www.youtube.com/channel/CHANNEL_ID)
cookies=$(grep -Eo "Cookie: (.*?);" <<< "$headers")

# Extract the data binary from the URL
data_binary=$(jq -r '.context | tojson' <<< "$headers")

# Login to YouTube
curl -s -k -X POST \
--url "https://www.youtube.com/youtubei/v1/session/create" \
--header "Host: www.youtube.com" \
--header "Content-Type: application/json" \
--header "Authorization: SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da" \
--header "Cookie: $cookies" \
--data-binary "$data_binary"

# Check if the login was successful
if [[ $? -eq 0 ]]; then
  echo "You have successfully logged in to YouTube\!"
else
  echo "Failed to login to YouTube\. Please try again\\\."
  exit 1
fi

# Get the channel ID from the URL
channel_id=$(echo $CHANNEL_ID | cut -d '/' -f 4)

# Subscribe to the channel
curl -s -k -X POST \
--url "https://www.youtube.com/youtubei/v1/channel/subscribe" \
--header "Host: www.youtube.com" \
--header "Content-Type: application/json" \
--header "Authorization: SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da" \
--header "Cookie: $cookies" \
--data-binary "$data_binary"

# Check if the subscription was successful
if [[ $? -eq 0 ]]; then
  echo "You have successfully subscribed to the YouTube channel!"
else
  echo "Failed to subscribe to the YouTube channel. Please try again."
  exit 1
fi

# Get the video IDs from the YouTube channel
video_ids=$(curl -s -k -X GET \
--url "https://www.youtube.com/channel/$channel_id/videos" \
--header "Host: www.youtube.com" \
--header "Cookie: $cookies" \
| jq -r '.items[].contentDetails.videoId')

# Like each video
for video_id in $video_ids; do
  curl -s -k -X POST \
  --url "https://www.youtube.com/youtubei/v1/like/add" \
  --header "Host: www.youtube.com" \
  --header "Content-Type: application/json" \
  --header "Authorization: SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da" \
  --header "Cookie: $cookies" \
  --data-binary '{
    "context": $data_binary,
    "input": {
      "contentId": "'"$video_id"'"
    }
  }'
done
