import requests
import json

# Get the headers and cookies from the URL
headers = requests.get("https://www.youtube.com/").headers
cookies = headers["Cookie"]

# Read the email and password from the CSV file
with open("input_data.csv", "r") as f:
    for line in f:
        email, password = line.strip().split(",")

        # Login to YouTube
        payload = {
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
                    "clientVersion": "2",
                },
            },
            "input": {
                "email": email,
                "password": password,
            },
        }

        response = requests.post(
            "https://www.youtube.com/youtubei/v1/session/create",
            headers={
                "Host": "www.youtube.com",
                "Content-Type": "application/json",
                "Authorization": "SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da",
                "Cookie": cookies,
            },
            data=json.dumps(payload),
        )

        # Check if the login was successful
        if response.status_code == 200:
            print("You have successfully logged in to YouTube!")

            # Get the YouTube channel IDs from the input data
            with open("input_data.txt", "r") as f:
                channel_ids = f.readlines()

            # Subscribe to all the YouTube channels
            for channel_id in channel_ids:
                payload = {
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
                            "clientVersion": "2",
                        },
                    },
                    "input": {
                        "channelIds": [channel_id],
                        "params": {},
                    },
                }

                response = requests.post(
                    "https://www.youtube.com/youtubei/v1/subscription/subscribe",
                    headers={
                        "Host": "www.youtube.com",
                        "Content-Type": "application/json",
                        "Authorization": "SAPISIDHASH 1696849094_7d72b0b84f669d92be0ed40086d61929525fa6da",
                        "Cookie": cookies,
                    },
                    data=json.dumps(payload),
                )

                # Check if the subscription was successful
                if response.status_code == 200:
                    print("You have successfully subscribed to the YouTube channel!")
                else:
                    print("Failed to subscribe to the YouTube channel. Please try again
