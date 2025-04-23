---
comments: true
title: Network Basics
date: 2019-06-03 12:00:00
# image:
#     path: /assets/img/images_preview/ProgrammingPreview.png
math: true
categories: [Programming and Development, Network Basics]
tags: [network, basics]
---

## HyperText Transfer Protocol (HTTP)

### HTTP Request Message

![http-request-message](/assets/img/images_network/http_request_message.png){: style="max-width: 600px; height: auto;"}

```python
import requests


api_url = "https://example.com/api"
params = {'key_1': 'value_1', 'key_2': 'value_2'}
header = {'User-Agent': 'MyApp/1.0', 'Authorization': 'Bearer SomeToken'}
data = {'usr_name': 'JohnDoe', 'usr_pwd': 'SomePassword'}

response = requests.post(
    url,
    params=params,
    headers=headers,
    data=data, # or json=data
)
```

This will generate the following HTTP request message

```text
POST /api?key_1=value_1&key_2=value_2 HTTP/1.1
Host: example.com
User-Agent: MyApp/1.0
Authorization: Bearer token123
Content-Type: application/x-www-form-urlencoded
Content-Length: 30

username=john&password=secret 
# if using json: {'usr_name': 'JohnDoe', 'usr_pwd': 'SomePassword'}
```

