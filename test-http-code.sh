#!/bin/bash

if [ $( curl -s -o /dev/null -I -w "%{http_code}" http://0.0.0.0:3000 ) == 302 ]; then
    echo "All good!" 
else
    echo "Server is not up!"
    exit 1
fi

