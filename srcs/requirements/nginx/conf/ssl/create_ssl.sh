#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout inception-nginx-selfsigned.key \
       -out inception-nginx-selfsigned.crt

# to view contents of cert: openssl x509 -in inception-nginx-selfsigned.crt -text -noout