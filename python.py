import requests

r = requests.post(
    # "http://54.176.115.222:4081/api/repos/turbalman/drone_test/builds/49",
  "http://54.176.115.222:4081/api/repos/turbalman/drone_test/builds?branch=main&key=value",
  headers={
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate",
    "Accept-Language": "en-US,en;q=0.9",
    "Connection": "keep-alive",
    "Content-Length": "0",
    "Cookie": "_session_=YF-rl3R1cmJhbG1hbkyvYhNxMfmbcEsTOrFeFbhfmfL4a53VTzZagcWIDQy7",
    "Host": "54.176.115.222:4081",
    "Origin": "http://54.176.115.222:4081",
    "Referer": "http://54.176.115.222:4081/turbalman/drone_test/48",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.192 Safari/537.36"
  }
)
print(r.text)
