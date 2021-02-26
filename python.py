import requests


def issue_cicd(branch="", commit="", value=""):
  r = requests.post(
    "http://54.176.115.222:4081/api/repos/turbalman/drone_test/builds?branch=" + branch + "&commit=" + commit + "&DRONE_BUILD_KEY=" + value,
    headers={
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
      "Content-Length": "0",
      "Cookie": "_session_=YF-rl3R1cmJhbG1hbkyvYhNxMfmbcEsTOrFeFbhfmfL4a53VTzZagcWIDQy7",
      "Host": "54.176.115.222:4081",
      "Origin": "http://54.176.115.222:4081",
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.192 Safari/537.36"
    }
  )
  print(r.text)


issue_cicd("main", "0f69c14928b4fcf84a971f9913ba122af4560de9", "")
