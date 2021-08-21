#!/bin/bash

if [ "$1" = "" ]
then
docker exec -it rails bash
else
docker exec -it rails bash -c \
"case "$1" in
"t" ) rspec ;;
"r" ) rubocop ;;
"l" ) tail -f -n 20 log/development.log ;;
esac"
fi