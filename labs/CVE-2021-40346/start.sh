#!/bin/sh

haproxy -f /usr/local/etc/haproxy/haproxy.cfg 
node app.js
