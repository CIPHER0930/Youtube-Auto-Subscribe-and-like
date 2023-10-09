import requests
import json

# Get the headers and cookies from the URL
headers = requests.get('https://www.youtube.com/channel/CHANNEL_ID').headers
cookies = headers['Cookie']

# Login to YouTube
login_data = {
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
      "clientVersion": "2"
    }
  },
  "input": {
    "email": "'"$email"'",
    "password": "'"$password"'"
  }
}

login_response = requests.post('https://www.youtube.com/youtubei/v1/session/create', headers=headers, cookies=cookies, data=json.dumps(login_data))

# Check if the login was successful
if login_response.status_code == 200:
  print('You have successfully logged in to YouTube!')
else:
  print('Failed to login to YouTube\. Please try again\.')
  exit(1)

# Get the video IDs from the YouTube channel
video_ids = requests.get('https://www.youtube.com/channel/CHANNEL_ID', headers=headers, cookies=cookies).content.decode('utf-8').split('\n')[-1].split('=')[-1]

# Like all the videos
for video_id in video_ids:
  like_data = {
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
        "clientVersion": "2"
      }
    },
    "videoId": "'"$video_id"'",
    "likeStatus": "LIKE"
  }

  like_response = requests.post('https://www.youtube.com/youtubei/v1/like/unlike', headers=headers, cookies=cookies, data=json.dumps(like_data))

  if like_response.status_code == 200:
    print('Successfully liked video {}!'.format(video_id))
  else:
    print('Failed to like video {}.'.format(video_id))
