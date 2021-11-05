#!/bin/bash

curl -X PUT -d '{
  "Acid": 12,
  "Umid": 10,
  "Temp": 4,
  "Wind": 22
}' 'https://ping-74a1b.firebaseio.com/parameters.json'

curl 'https://ping-74a1b.firebaseio.com/.json?print=pretty'