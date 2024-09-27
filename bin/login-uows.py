#!/usr/bin/env python

import tomllib
import urllib.request
import os
import sys
import json

with open(os.path.expanduser("~/.config/uows-creds.toml"), "rb") as f:
    creds = tomllib.load(f)

env = sys.argv[1] if len(sys.argv) > 1 else "local"
if env not in creds:
    print(f"Unknown env '{env}', must be one of {list(creds.keys())}")
    exit(1)

creds = creds[env]

url = creds['url'] + "/sessions"
body = {
        "username": creds["username"],
        "password": creds["password"]
}

req = urllib.request.Request(url, method="POST")
req.add_header("Content-type", "application/json")
data = json.dumps(body).encode()
with urllib.request.urlopen(req, data=data) as resp:
    if resp.status < 200 or resp.status > 299:
        print(f"Request failed with a {resp.status}")
    else:
        resp_body = json.loads(resp.read().decode())
        print(resp_body["sessionId"])
